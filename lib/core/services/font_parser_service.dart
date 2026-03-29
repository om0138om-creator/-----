import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/font_model.dart';
import '../constants/opentype_features.dart';

/// خدمة تحليل ملفات الخطوط واستخراج خصائص OpenType
class FontParserService {
  static final FontParserService _instance = FontParserService._internal();
  factory FontParserService() => _instance;
  FontParserService._internal();

  /// تحليل ملف خط من المسار
  Future<FontModel?> parseFromPath(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      
      final bytes = await file.readAsBytes();
      return parseFromBytes(bytes, path: path);
    } catch (e) {
      print('Error parsing font from path: $e');
      return null;
    }
  }

  /// تحليل ملف خط من البايتات
  Future<FontModel?> parseFromBytes(Uint8List bytes, {String? path}) async {
    try {
      // التحقق من نوع الملف
      final fontType = _detectFontType(bytes);
      if (fontType == FontType.unknown) {
        throw Exception('Unknown font format');
      }

      // قراءة جداول الخط
      final tables = _readFontTables(bytes, fontType);
      
      // استخراج المعلومات الأساسية
      final nameTable = _parseNameTable(bytes, tables['name']);
      final metadata = _parseHeadTable(bytes, tables['head'], tables['hhea'], tables['maxp']);
      
      // استخراج خصائص OpenType
      final features = _parseOpenTypeFeatures(bytes, tables);
      
      // استخراج محاور Variable Font
      final variableAxes = _parseVariableAxes(bytes, tables['fvar']);

      return FontModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameTable['fullName'] ?? nameTable['family'] ?? 'Unknown Font',
        family: nameTable['family'] ?? 'Unknown',
        path: path,
        bytes: bytes,
        isCustom: true,
        metadata: FontMetadata(
          copyright: nameTable['copyright'],
          designer: nameTable['designer'],
          designerUrl: nameTable['designerUrl'],
          manufacturer: nameTable['manufacturer'],
          manufacturerUrl: nameTable['vendorUrl'],
          license: nameTable['license'],
          licenseUrl: nameTable['licenseUrl'],
          version: nameTable['version'],
          description: nameTable['description'],
          trademark: nameTable['trademark'],
          unitsPerEm: metadata['unitsPerEm'],
          ascender: metadata['ascender'],
          descender: metadata['descender'],
          lineGap: metadata['lineGap'],
          numGlyphs: metadata['numGlyphs'],
        ),
        supportedFeatures: features,
        variableAxes: variableAxes,
      );
    } catch (e) {
      print('Error parsing font bytes: $e');
      return null;
    }
  }

  /// كشف نوع الخط
  FontType _detectFontType(Uint8List bytes) {
    if (bytes.length < 4) return FontType.unknown;
    
    // TrueType
    if (bytes[0] == 0x00 && bytes[1] == 0x01 && 
        bytes[2] == 0x00 && bytes[3] == 0x00) {
      return FontType.truetype;
    }
    
    // OpenType with CFF
    if (bytes[0] == 0x4F && bytes[1] == 0x54 && 
        bytes[2] == 0x54 && bytes[3] == 0x4F) {
      return FontType.opentype;
    }
    
    // TrueType Collection
    if (bytes[0] == 0x74 && bytes[1] == 0x74 && 
        bytes[2] == 0x63 && bytes[3] == 0x66) {
      return FontType.collection;
    }
    
    // WOFF
    if (bytes[0] == 0x77 && bytes[1] == 0x4F && 
        bytes[2] == 0x46 && bytes[3] == 0x46) {
      return FontType.woff;
    }
    
    // WOFF2
    if (bytes[0] == 0x77 && bytes[1] == 0x4F && 
        bytes[2] == 0x46 && bytes[3] == 0x32) {
      return FontType.woff2;
    }
    
    return FontType.unknown;
  }

  /// قراءة جداول الخط
  Map<String, TableEntry> _readFontTables(Uint8List bytes, FontType fontType) {
    final tables = <String, TableEntry>{};
    
    try {
      int offset = 4; // تخطي signature
      
      // قراءة عدد الجداول
      final numTables = _readUInt16(bytes, offset);
      offset = 12; // بداية سجلات الجداول
      
      for (var i = 0; i < numTables; i++) {
        final tag = String.fromCharCodes(bytes.sublist(offset, offset + 4));
        final checksum = _readUInt32(bytes, offset + 4);
        final tableOffset = _readUInt32(bytes, offset + 8);
        final length = _readUInt32(bytes, offset + 12);
        
        tables[tag] = TableEntry(
          tag: tag,
          checksum: checksum,
          offset: tableOffset,
          length: length,
        );
        
        offset += 16;
      }
    } catch (e) {
      print('Error reading font tables: $e');
    }
    
    return tables;
  }

  /// تحليل جدول الأسماء
  Map<String, String?> _parseNameTable(Uint8List bytes, TableEntry? nameTable) {
    final names = <String, String?>{};
    
    if (nameTable == null) return names;
    
    try {
      final offset = nameTable.offset;
      
      // قراءة header
      final format = _readUInt16(bytes, offset);
      final count = _readUInt16(bytes, offset + 2);
      final stringOffset = _readUInt16(bytes, offset + 4);
      
      // قراءة سجلات الأسماء
      var recordOffset = offset + 6;
      
      for (var i = 0; i < count; i++) {
        final platformId = _readUInt16(bytes, recordOffset);
        final encodingId = _readUInt16(bytes, recordOffset + 2);
        final languageId = _readUInt16(bytes, recordOffset + 4);
        final nameId = _readUInt16(bytes, recordOffset + 6);
        final length = _readUInt16(bytes, recordOffset + 8);
        final strOffset = _readUInt16(bytes, recordOffset + 10);
        
        // تفضيل Unicode/Windows
        if ((platformId == 0 || platformId == 3) && 
            (languageId == 0x0409 || languageId == 0)) {
          try {
            final strStart = offset + stringOffset + strOffset;
            final strBytes = bytes.sublist(strStart, strStart + length);
            
            String value;
            if (platformId == 3 || platformId == 0) {
              // UTF-16 BE
              value = _decodeUtf16Be(strBytes);
            } else {
              value = String.fromCharCodes(strBytes);
            }
            
            final nameKey = _getNameKey(nameId);
            if (nameKey != null && (names[nameKey] == null || platformId == 3)) {
              names[nameKey] = value;
            }
          } catch (_) {}
        }
        
        recordOffset += 12;
      }
    } catch (e) {
      print('Error parsing name table: $e');
    }
    
    return names;
  }

  /// الحصول على مفتاح الاسم
  String? _getNameKey(int nameId) {
    switch (nameId) {
      case 0: return 'copyright';
      case 1: return 'family';
      case 2: return 'subfamily';
      case 3: return 'uniqueId';
      case 4: return 'fullName';
      case 5: return 'version';
      case 6: return 'postscriptName';
      case 7: return 'trademark';
      case 8: return 'manufacturer';
      case 9: return 'designer';
      case 10: return 'description';
      case 11: return 'vendorUrl';
      case 12: return 'designerUrl';
      case 13: return 'license';
      case 14: return 'licenseUrl';
      case 16: return 'preferredFamily';
      case 17: return 'preferredSubfamily';
      default: return null;
    }
  }

  /// تحليل جدول head و hhea و maxp
  Map<String, int> _parseHeadTable(
    Uint8List bytes,
    TableEntry? head,
    TableEntry? hhea,
    TableEntry? maxp,
  ) {
    final info = <String, int>{};
    
    if (head != null) {
      try {
        info['unitsPerEm'] = _readUInt16(bytes, head.offset + 18);
      } catch (_) {}
    }
    
    if (hhea != null) {
      try {
        info['ascender'] = _readInt16(bytes, hhea.offset + 4);
        info['descender'] = _readInt16(bytes, hhea.offset + 6);
        info['lineGap'] = _readInt16(bytes, hhea.offset + 8);
      } catch (_) {}
    }
    
    if (maxp != null) {
      try {
        info['numGlyphs'] = _readUInt16(bytes, maxp.offset + 4);
      } catch (_) {}
    }
    
    return info;
  }

  /// ⭐ تحليل خصائص OpenType - الجزء الأهم!
  List<String> _parseOpenTypeFeatures(
    Uint8List bytes,
    Map<String, TableEntry> tables,
  ) {
    final features = <String>{};
    
    // تحليل جدول GSUB (Glyph Substitution)
    if (tables.containsKey('GSUB')) {
      final gsubFeatures = _parseLayoutTable(bytes, tables['GSUB']!);
      features.addAll(gsubFeatures);
    }
    
    // تحليل جدول GPOS (Glyph Positioning)
    if (tables.containsKey('GPOS')) {
      final gposFeatures = _parseLayoutTable(bytes, tables['GPOS']!);
      features.addAll(gposFeatures);
    }
    
    return features.toList()..sort();
  }

  /// تحليل جداول GSUB/GPOS
  List<String> _parseLayoutTable(Uint8List bytes, TableEntry table) {
    final features = <String>[];
    
    try {
      final offset = table.offset;
      
      // قراءة version
      final majorVersion = _readUInt16(bytes, offset);
      final minorVersion = _readUInt16(bytes, offset + 2);
      
      // قراءة offsets
      final scriptListOffset = _readUInt16(bytes, offset + 4);
      final featureListOffset = _readUInt16(bytes, offset + 6);
      
      // قراءة Feature List
      final featureListStart = offset + featureListOffset;
      final featureCount = _readUInt16(bytes, featureListStart);
      
      var featureRecordOffset = featureListStart + 2;
      
      for (var i = 0; i < featureCount; i++) {
        // قراءة Feature Tag (4 bytes)
        final featureTag = String.fromCharCodes(
          bytes.sublist(featureRecordOffset, featureRecordOffset + 4)
        ).trim();
        
        if (featureTag.isNotEmpty && 
            OpenTypeFeatures.allFeatures.containsKey(featureTag)) {
          features.add(featureTag);
        }
        
        featureRecordOffset += 6; // 4 bytes tag + 2 bytes offset
      }
    } catch (e) {
      print('Error parsing layout table: $e');
    }
    
    return features;
  }

  /// تحليل محاور Variable Font
  List<VariableAxis> _parseVariableAxes(Uint8List bytes, TableEntry? fvar) {
    final axes = <VariableAxis>[];
    
    if (fvar == null) return axes;
    
    try {
      final offset = fvar.offset;
      
      // قراءة header
      final majorVersion = _readUInt16(bytes, offset);
      final minorVersion = _readUInt16(bytes, offset + 2);
      final axesArrayOffset = _readUInt16(bytes, offset + 4);
      final reserved = _readUInt16(bytes, offset + 6);
      final axisCount = _readUInt16(bytes, offset + 8);
      final axisSize = _readUInt16(bytes, offset + 10);
      
      var axisOffset = offset + axesArrayOffset;
      
      for (var i = 0; i < axisCount; i++) {
        final tag = String.fromCharCodes(
          bytes.sublist(axisOffset, axisOffset + 4)
        );
        final minValue = _readFixed(bytes, axisOffset + 4);
        final defaultValue = _readFixed(bytes, axisOffset + 8);
        final maxValue = _readFixed(bytes, axisOffset + 12);
        final flags = _readUInt16(bytes, axisOffset + 16);
        final axisNameId = _readUInt16(bytes, axisOffset + 18);
        
        axes.add(VariableAxis(
          tag: tag,
          name: _getAxisName(tag),
          minValue: minValue,
          maxValue: maxValue,
          defaultValue: defaultValue,
        ));
        
        axisOffset += axisSize;
      }
    } catch (e) {
      print('Error parsing fvar table: $e');
    }
    
    return axes;
  }

  /// الحصول على اسم المحور
  String _getAxisName(String tag) {
    switch (tag) {
      case 'wght': return 'Weight';
      case 'wdth': return 'Width';
      case 'slnt': return 'Slant';
      case 'ital': return 'Italic';
      case 'opsz': return 'Optical Size';
      case 'GRAD': return 'Grade';
      case 'XTRA': return 'X Extra';
      case 'YOPQ': return 'Y Opaque';
      case 'YTLC': return 'Lowercase Height';
      case 'YTUC': return 'Uppercase Height';
      default: return tag;
    }
  }

  // ============= Helper Methods =============

  int _readUInt16(Uint8List bytes, int offset) {
    return (bytes[offset] << 8) | bytes[offset + 1];
  }

  int _readInt16(Uint8List bytes, int offset) {
    final value = _readUInt16(bytes, offset);
    return value >= 0x8000 ? value - 0x10000 : value;
  }

  int _readUInt32(Uint8List bytes, int offset) {
    return (bytes[offset] << 24) |
           (bytes[offset + 1] << 16) |
           (bytes[offset + 2] << 8) |
           bytes[offset + 3];
  }

  double _readFixed(Uint8List bytes, int offset) {
    final value = _readUInt32(bytes, offset);
    return value / 65536.0;
  }

  String _decodeUtf16Be(Uint8List bytes) {
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length - 1; i += 2) {
      final charCode = (bytes[i] << 8) | bytes[i + 1];
      if (charCode > 0) {
        buffer.writeCharCode(charCode);
      }
    }
    return buffer.toString();
  }
}

/// نوع الخط
enum FontType {
  truetype,
  opentype,
  collection,
  woff,
  woff2,
  unknown,
}

/// سجل جدول
class TableEntry {
  final String tag;
  final int checksum;
  final int offset;
  final int length;

  TableEntry({
    required this.tag,
    required this.checksum,
    required this.offset,
    required this.length,
  });
}

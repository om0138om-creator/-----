import 'dart:typed_data';

class FontModel {
  final String id;
  final String name;
  final String family;
  final String? path;
  final Uint8List? bytes;
  final bool isCustom;
  final DateTime addedAt;
  final FontMetadata metadata;
  final List<String> supportedFeatures;
  final List<VariableAxis> variableAxes;
  final bool isVariable;

  FontModel({
    required this.id,
    required this.name,
    required this.family,
    this.path,
    this.bytes,
    this.isCustom = false,
    DateTime? addedAt,
    FontMetadata? metadata,
    List<String>? supportedFeatures,
    List<VariableAxis>? variableAxes,
  })  : addedAt = addedAt ?? DateTime.now(),
        metadata = metadata ?? FontMetadata(),
        supportedFeatures = supportedFeatures ?? [],
        variableAxes = variableAxes ?? [],
        isVariable = (variableAxes?.isNotEmpty ?? false);

  /// نسخة من النموذج
  FontModel copyWith({
    String? id,
    String? name,
    String? family,
    String? path,
    Uint8List? bytes,
    bool? isCustom,
    DateTime? addedAt,
    FontMetadata? metadata,
    List<String>? supportedFeatures,
    List<VariableAxis>? variableAxes,
  }) {
    return FontModel(
      id: id ?? this.id,
      name: name ?? this.name,
      family: family ?? this.family,
      path: path ?? this.path,
      bytes: bytes ?? this.bytes,
      isCustom: isCustom ?? this.isCustom,
      addedAt: addedAt ?? this.addedAt,
      metadata: metadata ?? this.metadata,
      supportedFeatures: supportedFeatures ?? List.from(this.supportedFeatures),
      variableAxes: variableAxes ?? List.from(this.variableAxes),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family': family,
      'path': path,
      'isCustom': isCustom,
      'addedAt': addedAt.toIso8601String(),
      'metadata': metadata.toJson(),
      'supportedFeatures': supportedFeatures,
      'variableAxes': variableAxes.map((a) => a.toJson()).toList(),
    };
  }

  /// من JSON
  factory FontModel.fromJson(Map<String, dynamic> json) {
    return FontModel(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      path: json['path'],
      isCustom: json['isCustom'] ?? false,
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
      metadata: json['metadata'] != null
          ? FontMetadata.fromJson(json['metadata'])
          : FontMetadata(),
      supportedFeatures: json['supportedFeatures'] != null
          ? List<String>.from(json['supportedFeatures'])
          : [],
      variableAxes: json['variableAxes'] != null
          ? (json['variableAxes'] as List)
              .map((a) => VariableAxis.fromJson(a))
              .toList()
          : [],
    );
  }
}

/// بيانات الخط الوصفية
class FontMetadata {
  final String? copyright;
  final String? designer;
  final String? designerUrl;
  final String? manufacturer;
  final String? manufacturerUrl;
  final String? license;
  final String? licenseUrl;
  final String? version;
  final String? description;
  final String? trademark;
  final int? unitsPerEm;
  final int? ascender;
  final int? descender;
  final int? lineGap;
  final int? numGlyphs;

  FontMetadata({
    this.copyright,
    this.designer,
    this.designerUrl,
    this.manufacturer,
    this.manufacturerUrl,
    this.license,
    this.licenseUrl,
    this.version,
    this.description,
    this.trademark,
    this.unitsPerEm,
    this.ascender,
    this.descender,
    this.lineGap,
    this.numGlyphs,
  });

  Map<String, dynamic> toJson() {
    return {
      'copyright': copyright,
      'designer': designer,
      'designerUrl': designerUrl,
      'manufacturer': manufacturer,
      'manufacturerUrl': manufacturerUrl,
      'license': license,
      'licenseUrl': licenseUrl,
      'version': version,
      'description': description,
      'trademark': trademark,
      'unitsPerEm': unitsPerEm,
      'ascender': ascender,
      'descender': descender,
      'lineGap': lineGap,
      'numGlyphs': numGlyphs,
    };
  }

  factory FontMetadata.fromJson(Map<String, dynamic> json) {
    return FontMetadata(
      copyright: json['copyright'],
      designer: json['designer'],
      designerUrl: json['designerUrl'],
      manufacturer: json['manufacturer'],
      manufacturerUrl: json['manufacturerUrl'],
      license: json['license'],
      licenseUrl: json['licenseUrl'],
      version: json['version'],
      description: json['description'],
      trademark: json['trademark'],
      unitsPerEm: json['unitsPerEm'],
      ascender: json['ascender'],
      descender: json['descender'],
      lineGap: json['lineGap'],
      numGlyphs: json['numGlyphs'],
    );
  }
}

/// محور Variable Font
class VariableAxis {
  final String tag;
  final String name;
  final double minValue;
  final double maxValue;
  final double defaultValue;

  VariableAxis({
    required this.tag,
    required this.name,
    required this.minValue,
    required this.maxValue,
    required this.defaultValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'name': name,
      'minValue': minValue,
      'maxValue': maxValue,
      'defaultValue': defaultValue,
    };
  }

  factory VariableAxis.fromJson(Map<String, dynamic> json) {
    return VariableAxis(
      tag: json['tag'],
      name: json['name'],
      minValue: json['minValue']?.toDouble() ?? 0,
      maxValue: json['maxValue']?.toDouble() ?? 1000,
      defaultValue: json['defaultValue']?.toDouble() ?? 400,
    );
  }

  /// الأسماء العربية للمحاور
  String get nameAr {
    switch (tag) {
      case 'wght':
        return 'الوزن';
      case 'wdth':
        return 'العرض';
      case 'slnt':
        return 'الميل';
      case 'ital':
        return 'المائل';
      case 'opsz':
        return 'الحجم البصري';
      case 'GRAD':
        return 'التدرج';
      case 'XTRA':
        return 'العرض الإضافي';
      case 'YOPQ':
        return 'سمك Y';
      case 'YTLC':
        return 'ارتفاع الأحرف الصغيرة';
      case 'YTUC':
        return 'ارتفاع الأحرف الكبيرة';
      default:
        return name;
    }
  }
}

/// المحاور القياسية
class StandardVariableAxes {
  static const VariableAxis weight = VariableAxis(
    tag: 'wght',
    name: 'Weight',
    minValue: 100,
    maxValue: 900,
    defaultValue: 400,
  );

  static const VariableAxis width = VariableAxis(
    tag: 'wdth',
    name: 'Width',
    minValue: 50,
    maxValue: 200,
    defaultValue: 100,
  );

  static const VariableAxis slant = VariableAxis(
    tag: 'slnt',
    name: 'Slant',
    minValue: -90,
    maxValue: 90,
    defaultValue: 0,
  );

  static const VariableAxis italic = VariableAxis(
    tag: 'ital',
    name: 'Italic',
    minValue: 0,
    maxValue: 1,
    defaultValue: 0,
  );

  static const VariableAxis opticalSize = VariableAxis(
    tag: 'opsz',
    name: 'Optical Size',
    minValue: 6,
    maxValue: 144,
    defaultValue: 14,
  );
}

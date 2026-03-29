import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'layer_model.dart';

class ProjectModel {
  final String id;
  String name;
  final DateTime createdAt;
  DateTime modifiedAt;
  double canvasWidth;
  double canvasHeight;
  Color backgroundColor;
  String? backgroundImage;
  List<LayerModel> layers;
  int activeLayerIndex;
  
  ProjectModel({
    String? id,
    required this.name,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.canvasWidth = 1080,
    this.canvasHeight = 1920,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.backgroundImage,
    List<LayerModel>? layers,
    this.activeLayerIndex = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now(),
        layers = layers ?? [];

  /// نسخة من المشروع
  ProjectModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? modifiedAt,
    double? canvasWidth,
    double? canvasHeight,
    Color? backgroundColor,
    String? backgroundImage,
    List<LayerModel>? layers,
    int? activeLayerIndex,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? DateTime.now(),
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      layers: layers ?? List.from(this.layers),
      activeLayerIndex: activeLayerIndex ?? this.activeLayerIndex,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'canvasWidth': canvasWidth,
      'canvasHeight': canvasHeight,
      'backgroundColor': backgroundColor.value,
      'backgroundImage': backgroundImage,
      'layers': layers.map((l) => l.toJson()).toList(),
      'activeLayerIndex': activeLayerIndex,
    };
  }

  /// من JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      canvasWidth: json['canvasWidth']?.toDouble() ?? 1080,
      canvasHeight: json['canvasHeight']?.toDouble() ?? 1920,
      backgroundColor: Color(json['backgroundColor'] ?? 0xFFFFFFFF),
      backgroundImage: json['backgroundImage'],
      layers: (json['layers'] as List?)
              ?.map((l) => LayerModel.fromJson(l))
              .toList() ??
          [],
      activeLayerIndex: json['activeLayerIndex'] ?? 0,
    );
  }

  /// قوالب المشاريع
  static List<ProjectTemplate> get templates => [
    ProjectTemplate(
      name: 'Instagram Post',
      nameAr: 'منشور انستغرام',
      width: 1080,
      height: 1080,
      icon: '📱',
    ),
    ProjectTemplate(
      name: 'Instagram Story',
      nameAr: 'ستوري انستغرام',
      width: 1080,
      height: 1920,
      icon: '📲',
    ),
    ProjectTemplate(
      name: 'Facebook Post',
      nameAr: 'منشور فيسبوك',
      width: 1200,
      height: 630,
      icon: '👥',
    ),
    ProjectTemplate(
      name: 'Twitter Post',
      nameAr: 'تغريدة',
      width: 1200,
      height: 675,
      icon: '🐦',
    ),
    ProjectTemplate(
      name: 'YouTube Thumbnail',
      nameAr: 'صورة يوتيوب',
      width: 1280,
      height: 720,
      icon: '▶️',
    ),
    ProjectTemplate(
      name: 'A4 Document',
      nameAr: 'مستند A4',
      width: 2480,
      height: 3508,
      icon: '📄',
    ),
    ProjectTemplate(
      name: 'Business Card',
      nameAr: 'بطاقة عمل',
      width: 1050,
      height: 600,
      icon: '💳',
    ),
    ProjectTemplate(
      name: 'Custom',
      nameAr: 'مخصص',
      width: 1080,
      height: 1080,
      icon: '✏️',
    ),
  ];
}

class ProjectTemplate {
  final String name;
  final String nameAr;
  final double width;
  final double height;
  final String icon;

  const ProjectTemplate({
    required this.name,
    required this.nameAr,
    required this.width,
    required this.height,
    required this.icon,
  });
}

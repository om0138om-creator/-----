import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/providers/layer_provider.dart';
import '../../../core/models/layer_model.dart';

class LayersPanel extends StatelessWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        _buildHeader(context),
        
        // Layers List
        Expanded(
          child: Consumer<LayerProvider>(
            builder: (context, provider, child) {
              if (provider.layers.isEmpty) {
                return _buildEmptyState();
              }
              
              return ReorderableListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: provider.layers.length,
                onReorder: (oldIndex, newIndex) {
                  provider.reorderLayers(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final reversedIndex = provider.layers.length - 1 - index;
                  final layer = provider.layers[reversedIndex];
                  
                  return _LayerTile(
                    key: ValueKey(layer.id),
                    layer: layer,
                    isSelected: provider.selectedLayer?.id == layer.id,
                    onSelect: () => provider.selectLayer(layer.id),
                    onToggleVisibility: () => provider.toggleLayerVisibility(layer.id),
                    onToggleLock: () => provider.toggleLayerLock(layer.id),
                    onDelete: () => provider.deleteLayer(layer.id),
                    onDuplicate: () => provider.duplicateLayer(layer.id),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.layers, size: 20),
          const SizedBox(width: 8),
          const Text(
            'الطبقات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          
          // Add Layer Menu
          PopupMenuButton<String>(
            onSelected: (value) => _addLayer(context, value),
            icon: const Icon(Icons.add, size: 20),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'text',
                child: Row(
                  children: [
                    Icon(Icons.text_fields, size: 18),
                    SizedBox(width: 8),
                    Text('نص'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'image',
                child: Row(
                  children: [
                    Icon(Icons.image, size: 18),
                    SizedBox(width: 8),
                    Text('صورة'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'rectangle',
                child: Row(
                  children: [
                    Icon(Icons.square_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('مستطيل'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'circle',
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('دائرة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.layers_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد طبقات',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط + لإضافة طبقة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _addLayer(BuildContext context, String type) {
    final provider = context.read<LayerProvider>();
    
    switch (type) {
      case 'text':
        provider.addTextLayer();
        break;
      case 'image':
        provider.addImageLayer();
        break;
      case 'rectangle':
        provider.addShapeLayer(shapeType: ShapeType.rectangle);
        break;
      case 'circle':
        provider.addShapeLayer(shapeType: ShapeType.circle);
        break;
    }
  }
}

class _LayerTile extends StatelessWidget {
  final LayerModel layer;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onToggleVisibility;
  final VoidCallback onToggleLock;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _LayerTile({
    super.key,
    required this.layer,
    required this.isSelected,
    required this.onSelect,
    required this.onToggleVisibility,
    required this.onToggleLock,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppTheme.primaryColor.withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: AppTheme.primaryColor, width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // Drag Handle
                ReorderableDragStartListener(
                  index: 0,
                  child: Icon(
                    Icons.drag_indicator,
                    size: 16,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Layer Icon
                _buildLayerIcon(),
                const SizedBox(width: 8),
                
                // Layer Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        layer.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: layer.isVisible 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (layer.type == LayerType.text && layer.text != null)
                        Text(
                          layer.text!,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Visibility
                    GestureDetector(
                      onTap: onToggleVisibility,
                      child: Icon(
                        layer.isVisible 
                            ? Icons.visibility 
                            : Icons.visibility_off,
                        size: 16,
                        color: layer.isVisible 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Lock
                    GestureDetector(
                      onTap: onToggleLock,
                      child: Icon(
                        layer.isLocked 
                            ? Icons.lock 
                            : Icons.lock_open,
                        size: 16,
                        color: layer.isLocked 
                            ? AppTheme.warningColor
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // More Options
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'duplicate':
                            onDuplicate();
                            break;
                          case 'delete':
                            onDelete();
                            break;
                        }
                      },
                      icon: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 16),
                              SizedBox(width: 8),
                              Text('نسخ'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('حذف', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayerIcon() {
    IconData icon;
    Color color;
    
    switch (layer.type) {
      case LayerType.text:
        icon = Icons.text_fields;
        color = AppTheme.primaryColor;
        break;
      case LayerType.image:
        icon = Icons.image;
        color = AppTheme.secondaryColor;
        break;
      case LayerType.shape:
        icon = _getShapeIcon();
        color = AppTheme.accentColor;
        break;
      case LayerType.group:
        icon = Icons.folder;
        color = AppTheme.warningColor;
        break;
    }
    
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  IconData _getShapeIcon() {
    switch (layer.shapeType) {
      case ShapeType.rectangle:
        return Icons.square_outlined;
      case ShapeType.circle:
        return Icons.circle_outlined;
      case ShapeType.triangle:
        return Icons.change_history;
      case ShapeType.star:
        return Icons.star_outline;
      case ShapeType.polygon:
        return Icons.hexagon_outlined;
      case ShapeType.line:
        return Icons.horizontal_rule;
      case ShapeType.arrow:
        return Icons.arrow_forward;
      default:
        return Icons.square_outlined;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/project_provider.dart';
import '../../core/providers/layer_provider.dart';
import '../../core/providers/tool_provider.dart';
import '../../core/providers/font_provider.dart';
import '../../core/models/layer_model.dart';

import 'widgets/editor_canvas.dart';
import 'widgets/toolbar.dart';
import 'widgets/layers_panel.dart';
import 'widgets/properties_panel.dart';
import 'widgets/text_editor_panel.dart';
import 'widgets/opentype_panel.dart';
import 'widgets/bottom_tools.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with TickerProviderStateMixin {
  final GlobalKey _canvasKey = GlobalKey();
  final ScreenshotController _screenshotController = ScreenshotController();
  
  late AnimationController _panelAnimationController;
  late Animation<double> _panelAnimation;
  
  bool _showLayersPanel = false;
  bool _showPropertiesPanel = false;
  bool _showOpenTypePanel = false;
  
  @override
  void initState() {
    super.initState();
    
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _panelAnimation = CurvedAnimation(
      parent: _panelAnimationController,
      curve: Curves.easeInOut,
    );
    
    // تحميل الطبقات من المشروع
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = context.read<ProjectProvider>().currentProject;
      if (project != null) {
        context.read<LayerProvider>().setLayers(project.layers);
      }
    });
  }

  @override
  void dispose() {
    _panelAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Toolbar
              _buildTopToolbar(),
              
              // Main Content
              Expanded(
                child: Row(
                  children: [
                    // Left Panel (Layers)
                    if (_showLayersPanel) _buildLayersPanel(),
                    
                    // Canvas Area
                    Expanded(
                      child: _buildCanvasArea(),
                    ),
                    
                    // Right Panel (Properties / OpenType)
                    if (_showPropertiesPanel) _buildPropertiesPanel(),
                    if (_showOpenTypePanel) _buildOpenTypePanel(),
                  ],
                ),
              ),
              
              // Bottom Tools
              _buildBottomTools(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopToolbar() {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back Button
              IconButton(
                onPressed: () => _onWillPop().then((canPop) {
                  if (canPop) Navigator.pop(context);
                }),
                icon: const Icon(Icons.arrow_back_ios_new),
                tooltip: 'رجوع',
              ),
              
              // Project Name
              Expanded(
                child: GestureDetector(
                  onTap: () => _renameProject(),
                  child: Text(
                    projectProvider.currentProject?.name ?? 'مشروع',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              
              // Undo/Redo
              IconButton(
                onPressed: projectProvider.canUndo 
                    ? () => projectProvider.undo() 
                    : null,
                icon: const Icon(Icons.undo),
                tooltip: 'تراجع',
              ),
              IconButton(
                onPressed: projectProvider.canRedo 
                    ? () => projectProvider.redo() 
                    : null,
                icon: const Icon(Icons.redo),
                tooltip: 'إعادة',
              ),
              
              const VerticalDivider(width: 20),
              
              // Toggle Panels
              IconButton(
                onPressed: () => setState(() {
                  _showLayersPanel = !_showLayersPanel;
                }),
                icon: Icon(
                  Icons.layers,
                  color: _showLayersPanel ? AppTheme.primaryColor : null,
                ),
                tooltip: 'الطبقات',
              ),
              IconButton(
                onPressed: () => setState(() {
                  _showPropertiesPanel = !_showPropertiesPanel;
                  _showOpenTypePanel = false;
                }),
                icon: Icon(
                  Icons.tune,
                  color: _showPropertiesPanel ? AppTheme.primaryColor : null,
                ),
                tooltip: 'الخصائص',
              ),
              IconButton(
                onPressed: () => setState(() {
                  _showOpenTypePanel = !_showOpenTypePanel;
                  _showPropertiesPanel = false;
                }),
                icon: Icon(
                  Icons.text_fields,
                  color: _showOpenTypePanel ? AppTheme.primaryColor : null,
                ),
                tooltip: 'OpenType',
              ),
              
              const VerticalDivider(width: 20),
              
              // Export
              _buildExportButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportButton() {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleExport(value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'png',
          child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 10),
              Text('تصدير PNG'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'jpg',
          child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 10),
              Text('تصدير JPG'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share),
              SizedBox(width: 10),
              Text('مشاركة'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(Icons.save),
              SizedBox(width: 10),
              Text('حفظ المشروع'),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'تصدير',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvasArea() {
    return Consumer2<ProjectProvider, ToolProvider>(
      builder: (context, projectProvider, toolProvider, child) {
        final project = projectProvider.currentProject;
        if (project == null) {
          return const Center(child: Text('لا يوجد مشروع'));
        }
        
        return GestureDetector(
          onTap: () {
            // إلغاء تحديد الطبقات عند النقر على الخلفية
            context.read<LayerProvider>().deselectAll();
          },
          child: Container(
            color: AppTheme.backgroundColor,
            child: InteractiveViewer(
              transformationController: TransformationController(),
              minScale: 0.1,
              maxScale: 5.0,
              boundaryMargin: const EdgeInsets.all(200),
              child: Center(
                child: Screenshot(
                  controller: _screenshotController,
                  child: EditorCanvas(
                    key: _canvasKey,
                    project: project,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLayersPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 250,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: const LayersPanel(),
    );
  }

  Widget _buildPropertiesPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 300,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          left: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: const PropertiesPanel(),
    );
  }

  Widget _buildOpenTypePanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 320,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          left: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: const OpenTypePanel(),
    );
  }

  Widget _buildBottomTools() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const BottomTools(),
    );
  }

  Future<void> _handleExport(String type) async {
    final projectProvider = context.read<ProjectProvider>();
    
    switch (type) {
      case 'png':
      case 'jpg':
        final path = await projectProvider.exportAsImage(
          _canvasKey,
          format: type,
          pixelRatio: 3.0,
        );
        if (path != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم التصدير: $path'),
              action: SnackBarAction(
                label: 'مشاركة',
                onPressed: () => projectProvider.shareProject(path),
              ),
            ),
          );
        }
        break;
        
      case 'share':
        final path = await projectProvider.exportAsImage(
          _canvasKey,
          format: 'png',
        );
        if (path != null) {
          await projectProvider.shareProject(path);
        }
        break;
        
      case 'save':
        // حفظ الطبقات في المشروع
        final layers = context.read<LayerProvider>().layers;
        projectProvider.updateLayers(layers);
        await projectProvider.saveProject();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ المشروع'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
        break;
    }
  }

  Future<bool> _onWillPop() async {
    final projectProvider = context.read<ProjectProvider>();
    
    if (projectProvider.hasUnsavedChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تغييرات غير محفوظة'),
          content: const Text('هل تريد حفظ التغييرات قبل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('لا، خروج'),
            ),
            ElevatedButton(
              onPressed: () async {
                final layers = context.read<LayerProvider>().layers;
                projectProvider.updateLayers(layers);
                await projectProvider.saveProject();
                if (mounted) Navigator.pop(context, true);
              },
              child: const Text('حفظ وخروج'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  void _renameProject() {
    final projectProvider = context.read<ProjectProvider>();
    final controller = TextEditingController(
      text: projectProvider.currentProject?.name ?? '',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير اسم المشروع'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'اسم المشروع',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // تحديث الاسم
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

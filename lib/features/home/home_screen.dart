import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/project_provider.dart';
import '../../core/providers/font_provider.dart';
import '../../core/models/project_model.dart';
import '../editor/editor_screen.dart';
import '../fonts/fonts_screen.dart';
import 'widgets/project_card.dart';
import 'widgets/template_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Tabs
            _buildTabs(),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTemplatesTab(),
                  _buildProjectsTab(),
                  _buildFontsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.font_download_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Font Studio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'فونت ستوديو',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          // Settings
          IconButton(
            onPressed: () => _showSettings(),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        tabs: const [
          Tab(text: 'قوالب'),
          Tab(text: 'مشاريعي'),
          Tab(text: 'الخطوط'),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    final templates = ProjectModel.templates;
    
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        return TemplateCard(
          template: templates[index],
          onTap: () => _createFromTemplate(templates[index]),
        );
      },
    );
  }

  Widget _buildProjectsTab() {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) {
        if (provider.recentProjects.isEmpty) {
          return _buildEmptyState(
            icon: Icons.folder_open_outlined,
            title: 'لا توجد مشاريع',
            subtitle: 'أنشئ مشروعاً جديداً للبدء',
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: provider.recentProjects.length,
          itemBuilder: (context, index) {
            return ProjectCard(
              project: provider.recentProjects[index],
              onTap: () => _openProject(provider.recentProjects[index]),
              onDelete: () => _deleteProject(provider.recentProjects[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildFontsTab() {
    return Consumer<FontProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // زر استيراد خط
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () => _importFont(),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'استيراد خط جديد',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // قائمة الخطوط
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: provider.fonts.length,
                itemBuilder: (context, index) {
                  final font = provider.fonts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'ف',
                            style: TextStyle(
                              fontFamily: font.family,
                              fontSize: 24,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      title: Text(font.name),
                      subtitle: Text(
                        '${font.supportedFeatures.length} خاصية OpenType',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      trailing: font.isCustom
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteFont(font.id),
                            )
                          : null,
                      onTap: () => _showFontDetails(font),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _showNewProjectDialog(),
      icon: const Icon(Icons.add),
      label: const Text('مشروع جديد'),
      backgroundColor: AppTheme.primaryColor,
    );
  }

  void _showNewProjectDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewProjectSheet(
        onCreateProject: (name, width, height) {
          _createProject(name, width, height);
        },
      ),
    );
  }

  Future<void> _createProject(String name, double width, double height) async {
    await context.read<ProjectProvider>().createProject(
      name: name,
      width: width,
      height: height,
    );
    
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
    }
  }

  Future<void> _createFromTemplate(ProjectTemplate template) async {
    await context.read<ProjectProvider>().createFromTemplate(template);
    
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
    }
  }

  Future<void> _openProject(ProjectModel project) async {
    await context.read<ProjectProvider>().openProject(project);
    
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
    }
  }

  void _deleteProject(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المشروع'),
        content: Text('هل تريد حذف "${project.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProjectProvider>().deleteProject(project.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _importFont() async {
    final font = await context.read<FontProvider>().importFont();
    if (font != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم استيراد "${font.name}" بنجاح'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _deleteFont(String fontId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الخط'),
        content: const Text('هل تريد حذف هذا الخط؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FontProvider>().deleteCustomFont(fontId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showFontDetails(font) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FontsScreen(selectedFont: font),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'الإعدادات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('المظهر'),
              subtitle: const Text('داكن'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('حول التطبيق'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NewProjectSheet extends StatefulWidget {
  final Function(String name, double width, double height) onCreateProject;

  const _NewProjectSheet({required this.onCreateProject});

  @override
  State<_NewProjectSheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<_NewProjectSheet> {
  final _nameController = TextEditingController(text: 'مشروع جديد');
  final _widthController = TextEditingController(text: '1080');
  final _heightController = TextEditingController(text: '1920');

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          const Text(
            'مشروع جديد',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // اسم المشروع
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم المشروع',
              prefixIcon: Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: 15),
          
          // الأبعاد
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'العرض',
                    suffixText: 'px',
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.close, size: 20),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الارتفاع',
                    suffixText: 'px',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          // زر الإنشاء
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final width = double.tryParse(_widthController.text) ?? 1080;
              final height = double.tryParse(_heightController.text) ?? 1920;
              
              Navigator.pop(context);
              widget.onCreateProject(name, width, height);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text('إنشاء المشروع'),
            ),
          ),
        ],
      ),
    );
  }
}

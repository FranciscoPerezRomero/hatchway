import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../state/project_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/project_card.dart';

/// Galería de proyectos — puramente de lectura/listado. Crear y editar
/// ahora ocurre en ProjectDetailScreen, una vista separada (ver AppShell).
class DashboardScreen extends StatelessWidget {
  final ValueChanged<Project?> onOpenProject;

  const DashboardScreen({super.key, required this.onOpenProject});

  Future<void> _handleDelete(BuildContext context, Project project) async {
    final store = context.read<ProjectStore>();
    final confirmed = await confirmDeleteDialog(context, project.title);
    if (confirmed && project.id != null) {
      await store.deleteProject(project.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProjectStore>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 64, height: 4, color: AppColors.neonRed, margin: const EdgeInsets.only(bottom: AppSpacing.sm)),
                  Text('MIS PROYECTOS', style: AppTypography.display(fontSize: 32)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => onOpenProject(null),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('NUEVO PROYECTO'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),
          if (store.loading)
            Text('// cargando...', style: AppTypography.mono(fontSize: 12, color: AppColors.textSecondary)),
          if (store.error != null)
            Text('// ${store.error}', style: AppTypography.mono(fontSize: 12, color: AppColors.neonRed)),
          if (!store.loading && store.error == null && store.projects.isEmpty)
            Text('// no_hay_proyectos()', style: AppTypography.mono(fontSize: 12, color: AppColors.textMuted)),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 360,
                mainAxisExtent: 380,
                crossAxisSpacing: AppSpacing.xxl,
                mainAxisSpacing: AppSpacing.xxl,
              ),
              itemCount: store.projects.length,
              itemBuilder: (context, i) {
                final project = store.projects[i];
                return ProjectCard(
                  project: project,
                  onEdit: () => onOpenProject(project),
                  onDelete: () => _handleDelete(context, project),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

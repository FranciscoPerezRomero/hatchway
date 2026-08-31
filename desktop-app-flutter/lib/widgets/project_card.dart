import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

const _projectTypeLabels = {
  'web_app': 'Web App',
  'mobile_app': 'Mobile App',
  'api': 'API',
  'library': 'Library',
  'tool': 'Tool',
};

class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectCard({super.key, required this.project, required this.onEdit, required this.onDelete});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final thumbnail = (p.cardThumbnailUrl?.isNotEmpty ?? false) ? p.cardThumbnailUrl : p.heroImageUrl;
    final description = (p.cardShortDescription?.isNotEmpty ?? false) ? p.cardShortDescription : p.tagline;
    final (pubBorder, pubFg) = AppColors.publishedPillColors(p.isPublished);
    final (statusBorder, statusFg) = AppColors.statusPillColors(p.status);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(_hovering ? -2 : 0, _hovering ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.surfaceBlock,
          border: Border.all(color: _hovering ? AppColors.neonRed : AppColors.borderDim, width: 1.5),
          boxShadow: _hovering ? AppColors.hardShadow(offset: 5) : AppColors.hardShadow(color: AppColors.borderDim, offset: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: (thumbnail != null && thumbnail.isNotEmpty)
                      ? Image.network(
                          thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                if (_hovering)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        _iconBtn(Icons.edit_outlined, widget.onEdit),
                        const SizedBox(width: 6),
                        _iconBtn(Icons.delete_outline, widget.onDelete),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.sans(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _pill(_projectTypeLabels[p.projectType] ?? p.projectType, AppColors.borderDim, AppColors.textSecondary),
                      _pill(p.isPublished ? 'Publicado' : 'Borrador', pubBorder, pubFg),
                      if (p.status != null) _pill(p.status!, statusBorder, statusFg),
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.sans(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                  if ((p.repositoryUrl?.isNotEmpty ?? false) || (p.ctaPrimaryUrl?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        if (p.repositoryUrl?.isNotEmpty ?? false)
                          _linkIcon(Icons.code, p.repositoryUrl!),
                        if (p.ctaPrimaryUrl?.isNotEmpty ?? false)
                          _linkIcon(Icons.public, p.ctaPrimaryUrl!),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceBlockAlt,
      alignment: Alignment.center,
      child: Text('// sin_imagen()', style: AppTypography.mono(fontSize: 12, color: AppColors.textMuted)),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.85), border: Border.all(color: AppColors.borderWhite, width: 1)),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  Widget _pill(String text, Color borderColor, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fg == AppColors.textSecondary || fg == AppColors.textMuted ? Colors.transparent : fg.withValues(alpha: 0.1),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(text, style: AppTypography.mono(fontSize: 10, color: fg)),
    );
  }

  Widget _linkIcon(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        child: Icon(icon, size: 15, color: AppColors.textMuted),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/tech_category.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'chip_list_field.dart';

/// Categorías repetibles del tech stack, cada una con su propio
/// ChipListField de tecnologías, más un input para agregar categoría nueva.
class TechCategoryEditor extends StatefulWidget {
  final List<TechCategory> categories;
  final ValueChanged<List<TechCategory>> onChanged;

  const TechCategoryEditor({super.key, required this.categories, required this.onChanged});

  @override
  State<TechCategoryEditor> createState() => _TechCategoryEditorState();
}

class _TechCategoryEditorState extends State<TechCategoryEditor> {
  final _newCategoryController = TextEditingController();

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  void _addCategory() {
    final name = _newCategoryController.text.trim();
    if (name.isEmpty) return;
    widget.onChanged([...widget.categories, TechCategory(category: name.toUpperCase(), technologies: [])]);
    _newCategoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organiza las tecnologías por categoría (FRONTEND, BACKEND, DEVOPS…)',
          style: AppTypography.sans(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        for (int i = 0; i < widget.categories.length; i++) _categoryCard(i),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newCategoryController,
                style: AppTypography.sans(fontSize: 13),
                decoration: const InputDecoration(hintText: 'Nueva categoría'),
                onSubmitted: (_) => _addCategory(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            InkWell(
              onTap: _addCategory,
              child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(color: AppColors.neonRed, border: Border.all(color: AppColors.borderWhite, width: 1.5)),
                child: const Icon(Icons.add, size: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _categoryCard(int i) {
    final cat = widget.categories[i];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surfaceBlockAlt, border: Border.all(color: AppColors.borderDim, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: cat.category,
                  style: AppTypography.mono(fontSize: 13, color: AppColors.textPrimary, letterSpacing: 0.5),
                  decoration: const InputDecoration(hintText: 'Categoría (ej: FRONTEND)'),
                  onChanged: (v) => cat.category = v,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              InkWell(
                onTap: () => widget.onChanged([...widget.categories]..removeAt(i)),
                child: const Icon(Icons.delete_outline, size: 16, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ChipListField(
            items: cat.technologies,
            hintText: 'Tecnología — Enter para agregar',
            onChanged: (list) => setState(() => cat.technologies = list),
          ),
        ],
      ),
    );
  }
}

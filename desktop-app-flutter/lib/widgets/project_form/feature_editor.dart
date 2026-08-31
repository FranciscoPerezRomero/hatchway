import 'package:flutter/material.dart';
import '../../models/feature.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

const int kMaxFeatures = 3;

/// Repeatable {title, description} — máx 3, con índice mono "01/02/03".
class FeatureEditor extends StatelessWidget {
  final List<Feature> features;
  final ValueChanged<List<Feature>> onChanged;

  const FeatureEditor({super.key, required this.features, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < features.length; i++) _featureCard(context, i),
        if (features.length < kMaxFeatures)
          TextButton.icon(
            onPressed: () => onChanged([...features, Feature(title: '', description: '')]),
            icon: const Icon(Icons.add, size: 15, color: AppColors.neonRed),
            label: Text('AÑADIR FEATURE', style: AppTypography.mono(fontSize: 12, color: AppColors.neonRed)),
          ),
      ],
    );
  }

  Widget _featureCard(BuildContext context, int i) {
    final feat = features[i];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlockAlt,
        border: Border.all(color: AppColors.borderDim, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0${i + 1}',
                style: AppTypography.mono(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.neonRed),
              ),
              InkWell(
                onTap: () => onChanged([...features]..removeAt(i)),
                child: const Icon(Icons.delete_outline, size: 16, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            initialValue: feat.title,
            style: AppTypography.sans(fontSize: 13),
            decoration: const InputDecoration(hintText: 'Título de la feature'),
            onChanged: (v) => feat.title = v,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            initialValue: feat.description,
            maxLines: 2,
            style: AppTypography.sans(fontSize: 13),
            decoration: const InputDecoration(hintText: 'Qué hace y cómo se implementó (2-3 oraciones)'),
            onChanged: (v) => feat.description = v,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/glass.dart';

class SidebarNav extends StatelessWidget {
  const SidebarNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xxl),
      decoration: const BoxDecoration(
        color: AppColors.bgPanel,
        border: Border(right: BorderSide(color: AppColors.borderDim, width: 1.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                color: AppColors.neonRed,
                child: const Icon(Icons.layers_outlined, color: Colors.black, size: 16),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'HATCHWAY',
                style: AppTypography.mono(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),
          _navActive('PROYECTOS', Icons.dashboard_outlined),
          const SizedBox(height: AppSpacing.xs),
          _navDisabled('CLIENTES', Icons.people_outline),
          const SizedBox(height: AppSpacing.xs),
          _navDisabled('PAGOS', Icons.credit_card_outlined),
          const SizedBox(height: AppSpacing.xs),
          _navDisabled('REPORTES', Icons.bar_chart_outlined),
          const Spacer(),
          GlassSurface(
            blurSigma: 12,
            borderColor: AppColors.borderDim,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('// ROADMAP', style: AppTypography.mono(fontSize: 9, color: AppColors.neonRed, letterSpacing: 1)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Clientes, pagos y reportes llegan en próximas fases.',
                  style: AppTypography.sans(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navActive(String label, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: Color(0x1FFF2340),
        border: Border(left: BorderSide(color: AppColors.neonRed, width: 3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.neonRed),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.mono(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.neonRed, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _navDisabled(String label, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          const SizedBox(width: 3),
          const SizedBox(width: AppSpacing.sm - 3),
          Icon(icon, size: 15, color: AppColors.textMuted),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.mono(fontSize: 12, color: AppColors.textMuted, letterSpacing: 1)),
          const Spacer(),
          Text('PRONTO', style: AppTypography.mono(fontSize: 8, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

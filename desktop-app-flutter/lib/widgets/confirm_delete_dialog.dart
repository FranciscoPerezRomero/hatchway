import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

Future<bool> confirmDeleteDialog(BuildContext context, String title) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceBlock,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AppColors.neonRed, width: 1.5),
      ),
      title: Text('ELIMINAR PROYECTO', style: AppTypography.mono(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      content: Text('¿Eliminar "$title"?', style: AppTypography.sans(fontSize: 13)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('CANCELAR', style: AppTypography.mono(fontSize: 12, color: AppColors.textSecondary)),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: AppColors.neonRed, border: Border.all(color: AppColors.borderWhite, width: 1.5)),
            child: Text('ELIMINAR', style: AppTypography.mono(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black)),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

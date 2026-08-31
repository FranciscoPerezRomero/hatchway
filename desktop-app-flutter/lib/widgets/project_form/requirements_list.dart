import 'package:flutter/material.dart';
import '../../models/client_info.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Checklist repetible de requerimientos del cliente — añadir con Enter,
/// marcar como hecho, quitar. Mismo patrón add/remove que el resto del
/// formulario (chips, features, tech stack).
class RequirementsList extends StatefulWidget {
  final List<Requirement> items;
  final ValueChanged<List<Requirement>> onChanged;

  const RequirementsList({super.key, required this.items, required this.onChanged});

  @override
  State<RequirementsList> createState() => _RequirementsListState();
}

class _RequirementsListState extends State<RequirementsList> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onChanged([...widget.items, Requirement(text: text)]);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.items.length; i++) _row(i),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: AppTypography.sans(fontSize: 13),
                decoration: const InputDecoration(hintText: 'Nuevo requerimiento — Enter para agregar'),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            InkWell(
              onTap: _add,
              child: Container(
                padding: const EdgeInsets.all(11),
                color: AppColors.neonRed,
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(int i) {
    final req = widget.items[i];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              final updated = [...widget.items];
              updated[i] = Requirement(text: req.text, done: !req.done);
              widget.onChanged(updated);
            },
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: req.done ? AppColors.neonGreen : Colors.transparent,
                border: Border.all(color: req.done ? AppColors.neonGreen : AppColors.borderDim, width: 1.5),
              ),
              child: req.done ? const Icon(Icons.check, size: 12, color: Colors.black) : null,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              req.text,
              style: AppTypography.sans(
                fontSize: 12,
                color: req.done ? AppColors.textMuted : AppColors.textPrimary,
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.onChanged([...widget.items]..removeAt(i)),
            child: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

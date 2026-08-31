import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Campo reutilizable de "chips" removibles + input con agregar-al-Enter.
/// Usado para key_challenges (max 4), tags, metrics (max 4) y las
/// technologies de cada categoría del tech stack.
class ChipListField extends StatefulWidget {
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final String hintText;
  final int? maxItems;

  const ChipListField({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.maxItems,
  });

  @override
  State<ChipListField> createState() => _ChipListFieldState();
}

class _ChipListFieldState extends State<ChipListField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty || widget.items.contains(value)) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.items, value]);
    _controller.clear();
  }

  void _remove(String item) {
    widget.onChanged(widget.items.where((i) => i != item).toList());
  }

  @override
  Widget build(BuildContext context) {
    final atLimit = widget.maxItems != null && widget.items.length >= widget.maxItems!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.items.isNotEmpty)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: widget.items.map((item) => _chip(item)).toList(),
          ),
        if (widget.items.isNotEmpty) const SizedBox(height: AppSpacing.sm),
        if (!atLimit)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: AppTypography.sans(fontSize: 13),
                  decoration: InputDecoration(hintText: widget.hintText),
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              InkWell(
                onTap: _add,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.neonRed,
                    border: Border.all(color: AppColors.borderWhite, width: 1.5),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _chip(String item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlockAlt,
        border: Border.all(color: AppColors.borderDim, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item, style: AppTypography.sans(fontSize: 12)),
          const SizedBox(width: AppSpacing.xs),
          InkWell(
            onTap: () => _remove(item),
            child: const Icon(Icons.close, size: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

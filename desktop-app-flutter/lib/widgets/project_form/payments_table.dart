import 'package:flutter/material.dart';
import '../../models/payment_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Tabla de registro de pagos repetible: fecha, monto, estado.
/// Añadir/quitar filas, mismo patrón que el resto del formulario.
class PaymentsTable extends StatelessWidget {
  final List<PaymentEntry> entries;
  final ValueChanged<List<PaymentEntry>> onChanged;

  const PaymentsTable({super.key, required this.entries, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderDim, width: 1.5))),
          child: Row(
            children: [
              _headCell('FECHA'),
              _headCell('MONTO'),
              _headCell('ESTADO'),
              const SizedBox(width: 32),
            ],
          ),
        ),
        for (int i = 0; i < entries.length; i++) _row(i),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => onChanged([...entries, PaymentEntry()]),
          icon: const Icon(Icons.add, size: 15),
          label: Text('AGREGAR PAGO', style: AppTypography.mono(fontSize: 11)),
        ),
      ],
    );
  }

  Widget _headCell(String label) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(label, style: AppTypography.mono(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1)),
        ),
      );

  Widget _row(int i) {
    final entry = entries[i];
    final (border, fg) = AppColors.statusPillColors(entry.status == 'PAGADO' ? 'Live' : 'Deprecated');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderDim, width: 1))),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: entry.date,
              style: AppTypography.sans(fontSize: 12),
              decoration: const InputDecoration(hintText: 'AAAA-MM-DD', border: InputBorder.none, isDense: true),
              onChanged: (v) => entry.date = v,
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: entry.amount,
              style: AppTypography.sans(fontSize: 12),
              decoration: const InputDecoration(hintText: r'$0.00', border: InputBorder.none, isDense: true),
              onChanged: (v) => entry.amount = v,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: entry.status,
              isDense: true,
              decoration: const InputDecoration(border: InputBorder.none),
              items: kPaymentStatuses
                  .map((s) => DropdownMenuItem(value: s, child: Text(s, style: AppTypography.mono(fontSize: 10, color: fg))))
                  .toList(),
              onChanged: (v) {
                final updated = [...entries];
                updated[i] = PaymentEntry(date: entry.date, amount: entry.amount, status: v ?? entry.status);
                onChanged(updated);
              },
              dropdownColor: AppColors.surfaceBlockAlt,
              style: AppTypography.mono(fontSize: 10, color: fg),
              icon: Icon(Icons.expand_more, size: 14, color: border),
            ),
          ),
          SizedBox(
            width: 32,
            child: InkWell(
              onTap: () => onChanged([...entries]..removeAt(i)),
              child: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

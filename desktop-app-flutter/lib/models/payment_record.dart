/// Registro de pagos — concepto de UI local a esta sesión, igual que
/// ClientInfo: sin tabla en el backend todavía, nunca viaja a la API.
const List<String> kPaymentStatuses = ['PAGADO', 'PENDIENTE'];

class PaymentEntry {
  String date;
  String amount;
  String status;
  PaymentEntry({this.date = '', this.amount = '', this.status = 'PENDIENTE'});
}

class PaymentInfo {
  String totalCost;
  String monthlyPayment;
  List<PaymentEntry> entries;

  PaymentInfo({
    this.totalCost = '',
    this.monthlyPayment = '',
    List<PaymentEntry>? entries,
  }) : entries = entries ?? [];

  double get paidTotal => entries
      .where((e) => e.status == 'PAGADO')
      .fold(0.0, (sum, e) => sum + (double.tryParse(e.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0));

  double get remaining {
    final total = double.tryParse(totalCost.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final r = total - paidTotal;
    return r < 0 ? 0 : r;
  }
}

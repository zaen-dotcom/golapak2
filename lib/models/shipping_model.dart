class ShippingTransactionModel {
  final int id;
  final String transactionCode;
  final int totalQty;
  final int grandTotal;
  final String date;
  final String status;

  ShippingTransactionModel({
    required this.id,
    required this.transactionCode,
    required this.totalQty,
    required this.grandTotal,
    required this.date,
    required this.status,
  });

  factory ShippingTransactionModel.fromJson(Map<String, dynamic> json) {
    return ShippingTransactionModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      transactionCode: json['transaction_code'] ?? '',
      totalQty: int.tryParse(json['total_qty'].toString()) ?? 0,
      grandTotal: int.tryParse(json['grand_total'].toString()) ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

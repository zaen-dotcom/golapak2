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
      id: json['id'],
      transactionCode: json['transaction_code'],
      totalQty: json['total_qty'],
      grandTotal: json['grand_total'],
      date: json['date'],
      status: json['status'],
    );
  }
}

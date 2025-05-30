class Order {
  final int id;
  final String transactionCode;
  final int totalQty;
  final int grandTotal;
  final DateTime date;
  final String status;

  Order({
    required this.id,
    required this.transactionCode,
    required this.totalQty,
    required this.grandTotal,
    required this.date,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      transactionCode: json['transaction_code'],
      totalQty: int.tryParse(json['total_qty'].toString()) ?? 0,
      grandTotal: int.tryParse(json['grand_total'].toString()) ?? 0,
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}

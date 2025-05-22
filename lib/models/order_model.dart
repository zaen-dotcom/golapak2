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
      id: json['id'] as int,
      transactionCode: json['transaction_code'] as String,
      totalQty: json['total_qty'] as int,
      grandTotal: json['grand_total'] as int,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );
  }
}

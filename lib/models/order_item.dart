class OrderItem {
  final int id;
  final String name;
  final int qty;
  final int mainCost;
  final int mainSubtotal;

  OrderItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.mainCost,
    required this.mainSubtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      mainCost: json['main_cost'],
      mainSubtotal: json['main_subtotal'],
    );
  }
}
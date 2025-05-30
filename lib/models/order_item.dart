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
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      qty: int.tryParse(json['qty'].toString()) ?? 0,
      mainCost: int.tryParse(json['main_cost'].toString()) ?? 0,
      mainSubtotal: int.tryParse(json['main_subtotal'].toString()) ?? 0,
    );
  }
}

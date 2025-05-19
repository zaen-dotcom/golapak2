import 'package:flutter/material.dart';

class OrderItemTile extends StatelessWidget {
  final String name;
  final int qty;
  final double price;

  const OrderItemTile({
    super.key,
    required this.name,
    required this.qty,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    double subtotal = qty * price;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text("$name x$qty")),
          Text("\$${subtotal.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}

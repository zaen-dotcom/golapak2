import 'order_item.dart';
import 'shipping_address.dart';
import '../services/transaction_service.dart';

class OrderDetail {
  final int id;
  final String transactionCode;
  final int totalQty;
  final int totalMainCost;
  final int deliveryFee;
  final int grandTotal;
  final DateTime date;
  final String status;
  final List<OrderItem> items;
  final ShippingAddress shipping;

  OrderDetail({
    required this.id,
    required this.transactionCode,
    required this.totalQty,
    required this.totalMainCost,
    required this.deliveryFee,
    required this.grandTotal,
    required this.date,
    required this.status,
    required this.items,
    required this.shipping,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final transaction = json['transaction'];
    final details = json['details'] as List<dynamic>;
    final shippingList = json['shipping'] as List<dynamic>;

    return OrderDetail(
      id: transaction['id'],
      transactionCode: transaction['transaction_code'],
      totalQty: int.tryParse(transaction['total_qty'].toString()) ?? 0,
      totalMainCost:
          int.tryParse(transaction['total_main_cost'].toString()) ?? 0,
      deliveryFee: int.tryParse(transaction['delivery_fee'].toString()) ?? 0,
      grandTotal: int.tryParse(transaction['grand_total'].toString()) ?? 0,
      date: DateTime.parse(transaction['date']),
      status: transaction['status'],
      items: details.map((item) => OrderItem.fromJson(item)).toList(),
      shipping: ShippingAddress.fromJson(shippingList.first),
    );
  }

  static Future<OrderDetail> fetchOrderDetail(String orderId) async {
    final data = await fetchOrderDetailFromApi(orderId);
    return OrderDetail.fromJson(data);
  }
}

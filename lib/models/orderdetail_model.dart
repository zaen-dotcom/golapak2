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
      totalQty: transaction['total_qty'],
      totalMainCost: transaction['total_main_cost'],
      deliveryFee: transaction['delivery_fee'],
      grandTotal: transaction['grand_total'],
      date: DateTime.parse(transaction['date']),
      status: transaction['status'],
      items: details.map((item) => OrderItem.fromJson(item)).toList(),
      shipping: ShippingAddress.fromJson(shippingList.first), // ambil data pertama saja
    );
  }


  static Future<OrderDetail> fetchOrderDetail(String orderId) async {
    // Panggil API dengan orderId, misal di transaction_service.dart
    final responseJson = await fetchOrderDetailFromApi(orderId);
    // Pastikan responseJson sudah berupa Map<String, dynamic>
    return OrderDetail.fromJson(responseJson['data']);
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/box_container.dart';
import '../components/menuitem.dart';
import '../screens/profile/hubungikami.dart';
import '../models/orderdetail_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<OrderDetail> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = OrderDetail.fetchOrderDetail(widget.orderId);
  }

  void _navigateToContactSeller(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ContactUsScreen()));
  }

  String formatCurrency(int number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFC107);
      case 'cooking':
        return const Color(0xFFFF7043);
      case 'on_delivery':
        return const Color(0xFF42A5F5);
      case 'done':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFE57373);
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Detail Pesanan',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<OrderDetail>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Data tidak ditemukan',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          final data = snapshot.data!;
          final dateFormatted = DateFormat(
            'dd MMM yyyy, HH:mm',
          ).format(data.date);
          final statusColor = getStatusColor(data.status);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(title: "Alamat Pengiriman"),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: WhiteBoxContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          icon: Icons.person_rounded,
                          text: data.shipping.name,
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.phone_rounded,
                          text: data.shipping.phoneNumber,
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.location_on_rounded,
                          text: data.shipping.address,
                          theme: theme,
                          iconColor: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SectionTitle(title: "Produk Dipesan"),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: WhiteBoxContainer(
                    child: Column(
                      children:
                          data.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.fastfood_rounded,
                                    color: Colors.orange.shade600,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${item.name} x${item.qty}',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    formatCurrency(item.mainSubtotal),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SectionTitle(title: "Ringkasan Transaksi"),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: WhiteBoxContainer(
                    child: Column(
                      children: [
                        _transactionRow(
                          "Total Produk",
                          formatCurrency(data.totalMainCost),
                          theme: theme,
                        ),
                        const SizedBox(height: 8),
                        _transactionRow(
                          "Ongkos Kirim",
                          formatCurrency(data.deliveryFee),
                          theme: theme,
                        ),
                        const Divider(height: 24, thickness: 1),
                        _transactionRow(
                          "Grand Total",
                          formatCurrency(data.grandTotal),
                          theme: theme,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Status: ${data.status}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dateFormatted,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SectionTitle(title: "Butuh Bantuan?"),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: WhiteBoxContainer(
                    child: MenuItem(
                      icon: Icons.support_agent_rounded,
                      text: 'Hubungi Penjual',
                      iconColor: Colors.indigo.shade600,
                      onTap: () => _navigateToContactSeller(context),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required ThemeData theme,
    Color? iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor ?? Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _transactionRow(
    String title,
    String value, {
    required ThemeData theme,
    bool isBold = false,
  }) {
    final style = theme.textTheme.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
      color: isBold ? Colors.black87 : Colors.grey.shade700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: style), Text(value, style: style)],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

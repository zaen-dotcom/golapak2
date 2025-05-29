import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/transfer_data.dart';

class ChooseTransferMethodPage extends StatefulWidget {
  final int totalAmount;
  final String? selectedBank;
  final ValueChanged<String?>? onChanged;

  const ChooseTransferMethodPage({
    Key? key,
    required this.totalAmount,
    this.selectedBank,
    this.onChanged,
  }) : super(key: key);

  @override
  _ChooseTransferMethodPageState createState() =>
      _ChooseTransferMethodPageState();
}

class _ChooseTransferMethodPageState extends State<ChooseTransferMethodPage> {
  late String? selectedBank;

  @override
  void initState() {
    super.initState();
    selectedBank = widget.selectedBank;
  }

  IconData _getBankIcon(String name) {
    switch (name) {
      case 'DANA':
        return FontAwesomeIcons.wallet;
      case 'BRI':
      case 'BCA':
        return FontAwesomeIcons.buildingColumns;
      default:
        return FontAwesomeIcons.moneyBill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Metode Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transferMethods.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final name = transferMethods[index]['name']!;
            final isSelected = selectedBank == name;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedBank = name;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(name);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaIcon(
                      _getBankIcon(name),
                      color: isSelected ? Colors.blue : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.blue.shade900 : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

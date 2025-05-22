import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransferMethodsWidget extends StatelessWidget {
  final String? selectedBank;
  final Function(String?) onChanged;

  const TransferMethodsWidget({
    super.key,
    required this.selectedBank,
    required this.onChanged,
  });

  IconData _getBankIcon(String name) {
    switch (name) {
      case 'DANA':
        return FontAwesomeIcons.wallet;
      case 'BRI':
        return FontAwesomeIcons.buildingColumns;
      case 'BCA':
        return FontAwesomeIcons.university;
      default:
        return FontAwesomeIcons.moneyBill;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> methods = [
      {'name': 'DANA', 'rekening': '0812-3456-7890'},
      {'name': 'BRI', 'rekening': '1234 5678 9012 3456'},
      {'name': 'BCA', 'rekening': '9876 5432 1098 7654'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          methods.map((method) {
            final icon = _getBankIcon(method['name']!);

            return ListTile(
              leading: Radio<String>(
                value: method['name']!,
                groupValue: selectedBank,
                onChanged: onChanged,
              ),
              title: Row(
                children: [
                  FaIcon(icon, size: 20, color: Colors.blue[800]),
                  const SizedBox(width: 8),
                  Text(method['name']!),
                ],
              ),
            );
          }).toList(),
    );
  }
}

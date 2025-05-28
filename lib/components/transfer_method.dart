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
        return FontAwesomeIcons.buildingColumns;
      case 'BCA':
        return FontAwesomeIcons.buildingColumns;
      default:
        return FontAwesomeIcons.moneyBill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          transferMethods.map((method) {
            final name = method['name']!;
            return ListTile(
              leading: Radio<String>(
                value: name,
                groupValue: selectedBank,
                onChanged: (val) {
                  setState(() {
                    selectedBank = val;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(val);
                  }
                },
              ),
              title: Row(
                children: [
                  FaIcon(_getBankIcon(name), size: 20, color: Colors.blue[800]),
                  const SizedBox(width: 8),
                  Text(name),
                ],
              ),
            );
          }).toList(),
    );
  }
}

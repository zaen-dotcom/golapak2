import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';

class AlamatList extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSelect;

  const AlamatList({super.key, this.onSelect});

  @override
  State<AlamatList> createState() => _AlamatListState();
}

class _AlamatListState extends State<AlamatList> {
  int? _selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final alamatProvider = Provider.of<AlamatProvider>(context);

    if (_selectedIndex == null && alamatProvider.alamatList.isNotEmpty) {
      final mainIndex = alamatProvider.alamatList.indexWhere(
        (alamat) => alamat['main_address'] == 1,
      );
      setState(() {
        _selectedIndex = mainIndex >= 0 ? mainIndex : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightGreyBlue = Color(0xFFF2F6F9);

    return Consumer<AlamatProvider>(
      builder: (context, alamatProvider, _) {
        if (alamatProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (alamatProvider.alamatList.isEmpty) {
          return const Center(child: Text('Tidak ada alamat yang tersedia'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: alamatProvider.alamatList.length,
          itemBuilder: (context, index) {
            final alamat = alamatProvider.alamatList[index];
            final isMain = alamat['main_address'] == 1;
            final isSelected = index == _selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });

                // Simpan ke provider
                Provider.of<AlamatProvider>(context, listen: false)
                    .setSelectedAlamat(alamat);

                // Callback ke parent
                if (widget.onSelect != null) {
                  widget.onSelect!(alamat);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : lightGreyBlue,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _selectedIndex,
                      onChanged: (value) {
                        setState(() {
                          _selectedIndex = value;
                        });

                        Provider.of<AlamatProvider>(context, listen: false)
                            .setSelectedAlamat(alamat);

                        if (widget.onSelect != null) {
                          widget.onSelect!(alamat);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alamat['name'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alamat['phone_number'] ?? '-',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alamat['address'] ?? '-',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isMain ? Icons.home : Icons.location_on_outlined,
                        color: isMain ? Colors.blue : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

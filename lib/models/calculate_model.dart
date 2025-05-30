class TransactionSummary {
  final int totalHargaProduk;
  final String biayaOngkir;
  final int totalBiayaPembayaran;
  final List<TransactionDetail> details;

  TransactionSummary({
    required this.totalHargaProduk,
    required this.biayaOngkir,
    required this.totalBiayaPembayaran,
    required this.details,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      totalHargaProduk: json['total_harga_produk'] ?? 0,
      biayaOngkir: json['biaya_ongkir'] ?? '0',
      totalBiayaPembayaran: json['total_biaya_pembayaran'] ?? 0,
      details:
          (json['details'] as List<dynamic>? ?? [])
              .map((item) => TransactionDetail.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_harga_produk': totalHargaProduk,
      'biaya_ongkir': biayaOngkir,
      'total_biaya_pembayaran': totalBiayaPembayaran,
      'details': details.map((item) => item.toJson()).toList(),
    };
  }
}

class TransactionDetail {
  final String id;
  final String nama;
  final String gambar;
  final int qty;
  final String price;
  final int subtotal;

  TransactionDetail({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      gambar: json['gambar'] ?? '',
      qty: json['qty'] ?? 0,
      price: json['price'] ?? '0',
      subtotal: json['subtotal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'gambar': gambar,
      'qty': qty,
      'price': price,
      'subtotal': subtotal,
    };
  }
}

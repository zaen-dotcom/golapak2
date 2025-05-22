class ProductModel {
  final int id;
  final String name;
  final String image;
  final double mainCost;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.mainCost,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id:
          json['id'] != null
              ? (json['id'] is int
                  ? json['id']
                  : int.tryParse(json['id'].toString()) ?? 0)
              : 0,
      name: json['name'] ?? '',
      image:
          json['image'] != null && json['image'] != ''
              ? 'http://10.0.2.2:8000/storage/${json['image']}'
              : 'http://10.0.2.2:8000/storage/default-image.png',
      mainCost:
          json['main_cost'] != null
              ? (json['main_cost'] is num
                  ? (json['main_cost'] as num).toDouble()
                  : double.tryParse(json['main_cost'].toString()) ?? 0.0)
              : 0.0,
    );
  }
}

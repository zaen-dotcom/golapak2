class ProductModel {
  final String name;
  final String image;
  final double mainCost;

  ProductModel({
    required this.name,
    required this.image,
    required this.mainCost,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      image: 'http://10.0.2.2:8000/storage/${json['image']}',
      mainCost: (json['main_cost'] as num).toDouble(),
    );
  }
}

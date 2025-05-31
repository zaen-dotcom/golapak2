import '../services/api_config.dart';

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
    String rawImage = json['image'] ?? '';
    String imageUrl =
        rawImage.isNotEmpty
            ? '${ApiConfig.imageBaseUrl}$rawImage'
            : '${ApiConfig.imageBaseUrl}default-image.png';
    return ProductModel(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      image: imageUrl,
      mainCost:
          json['main_cost'] is num
              ? (json['main_cost'] as num).toDouble()
              : double.tryParse(json['main_cost'].toString()) ?? 0.0,
    );
  }
}

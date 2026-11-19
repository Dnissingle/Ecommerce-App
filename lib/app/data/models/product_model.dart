class ProductModel {
  int id;
  String image;
  String name;
  String description;
  int quantity;
  double price;
  int? categoryId;
  String unit;
  int stockQuantity;
  bool isFeatured;

  ProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
    this.categoryId,
    this.unit = 'kg',
    this.stockQuantity = 0,
    this.isFeatured = false,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    int quantity = 0,
  }) {
    return ProductModel(
      id: (json['id'] as num).toInt(),
      image: json['image_path'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      quantity: quantity,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      unit: json['unit'] as String? ?? 'kg',
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }
}

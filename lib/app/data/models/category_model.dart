class CategoryModel {
  int id;
  String title;
  String image;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num).toInt(),
      title: json['name'] as String,
      image: json['image_path'] as String? ?? '',
    );
  }
}

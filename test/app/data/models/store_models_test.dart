import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_app/app/data/models/category_model.dart';
import 'package:grocery_app/app/data/models/product_model.dart';

void main() {
  test('maps a Supabase product row into a product model', () {
    final product = ProductModel.fromJson(
      {
        'id': 42,
        'category_id': 3,
        'name': 'Apples',
        'description': 'Crisp apples',
        'image_path': 'https://example.com/apples.png',
        'price': 2.5,
        'unit': 'kg',
        'stock_quantity': 12,
        'is_featured': true,
      },
      quantity: 2,
    );

    expect(product.id, 42);
    expect(product.categoryId, 3);
    expect(product.price, 2.5);
    expect(product.quantity, 2);
    expect(product.stockQuantity, 12);
    expect(product.isFeatured, isTrue);
  });

  test('maps a Supabase category row into a category model', () {
    final category = CategoryModel.fromJson({
      'id': 7,
      'name': 'Fruit',
      'image_path': 'assets/vectors/apple.svg',
    });

    expect(category.id, 7);
    expect(category.title, 'Fruit');
    expect(category.image, 'assets/vectors/apple.svg');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:carrito_compras/features/products/data/models/product_model.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';

void main() {
  group('ProductModel', () {
    const testProductModel = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 19.99,
      description: 'A test product description',
      category: 'electronics',
      image: 'https://fakestoreapi.com/img/test.jpg',
      rating: ProductRatingModel(rate: 4.5, count: 250),
    );

    final testProductJson = {
      'id': 1,
      'title': 'Test Product',
      'price': 19.99,
      'description': 'A test product description',
      'category': 'electronics',
      'image': 'https://fakestoreapi.com/img/test.jpg',
      'rating': {'rate': 4.5, 'count': 250},
    };

    test('debe ser una subclase de Product entity', () {
      expect(testProductModel, isA<Product>());
    });

    group('fromJson', () {
      test('debe retornar un modelo válido desde JSON', () {
        final result = ProductModel.fromJson(testProductJson);

        expect(result.id, testProductModel.id);
        expect(result.title, testProductModel.title);
        expect(result.price, testProductModel.price);
        expect(result.description, testProductModel.description);
        expect(result.category, testProductModel.category);
        expect(result.image, testProductModel.image);
        expect(result.rating.rate, testProductModel.rating.rate);
        expect(result.rating.count, testProductModel.rating.count);
      });

      test('debe manejar precio como int', () {
        final jsonWithIntPrice = Map<String, dynamic>.from(testProductJson);
        jsonWithIntPrice['price'] = 20;

        final result = ProductModel.fromJson(jsonWithIntPrice);

        expect(result.price, 20.0);
      });
    });

    group('toJson', () {
      test('debe retornar un mapa JSON con los datos correctos', () {
        final result = testProductModel.toJson();

        expect(result['id'], testProductJson['id']);
        expect(result['title'], testProductJson['title']);
        expect(result['price'], testProductJson['price']);
        expect(result['description'], testProductJson['description']);
        expect(result['category'], testProductJson['category']);
        expect(result['image'], testProductJson['image']);
        expect(
          result['rating']['rate'],
          (testProductJson['rating'] as Map)['rate'],
        );
        expect(
          result['rating']['count'],
          (testProductJson['rating'] as Map)['count'],
        );
      });
    });

    group('fromEntity', () {
      test('debe crear ProductModel desde Product entity', () {
        const product = Product(
          id: 5,
          title: 'Entity Product',
          price: 29.99,
          description: 'From entity',
          category: 'clothing',
          image: 'https://example.com/image.jpg',
          rating: ProductRating(rate: 3.8, count: 50),
        );

        final result = ProductModel.fromEntity(product);

        expect(result.id, product.id);
        expect(result.title, product.title);
        expect(result.price, product.price);
        expect(result.description, product.description);
        expect(result.category, product.category);
        expect(result.image, product.image);
        expect(result.rating.rate, product.rating.rate);
        expect(result.rating.count, product.rating.count);
      });
    });
  });

  group('ProductRatingModel', () {
    const testRatingModel = ProductRatingModel(rate: 4.2, count: 150);
    final testRatingJson = {'rate': 4.2, 'count': 150};

    test('debe ser una subclase de ProductRating entity', () {
      expect(testRatingModel, isA<ProductRating>());
    });

    test('fromJson debe retornar un modelo válido', () {
      final result = ProductRatingModel.fromJson(testRatingJson);

      expect(result.rate, testRatingModel.rate);
      expect(result.count, testRatingModel.count);
    });

    test('toJson debe retornar un mapa JSON correcto', () {
      final result = testRatingModel.toJson();

      expect(result['rate'], testRatingJson['rate']);
      expect(result['count'], testRatingJson['count']);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';

void main() {
  group('CartItem', () {
    const testProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 25.99,
      description: 'A test product',
      category: 'test',
      image: 'https://example.com/image.jpg',
      rating: ProductRating(rate: 4.5, count: 100),
    );

    test('el subtotal debe calcularse correctamente', () {
      const cartItem = CartItem(product: testProduct, quantity: 3);
      expect(cartItem.subtotal, 77.97);
    });

    test('el subtotal debe ser 0 cuando la cantidad es 0', () {
      const cartItem = CartItem(product: testProduct, quantity: 0);
      expect(cartItem.subtotal, 0.0);
    });

    test('copyWith debe crear una nueva instancia con campos actualizados', () {
      const original = CartItem(product: testProduct, quantity: 1);
      final updated = original.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.product, testProduct);
      expect(updated.subtotal, 129.95);
    });

    test('copyWith sin cambios retorna instancia equivalente', () {
      const original = CartItem(product: testProduct, quantity: 2);
      final copied = original.copyWith();

      expect(copied.quantity, original.quantity);
      expect(copied.product, original.product);
    });

    test('dos CartItems con mismos valores deben ser iguales', () {
      const item1 = CartItem(product: testProduct, quantity: 2);
      const item2 = CartItem(product: testProduct, quantity: 2);

      expect(item1, equals(item2));
    });

    test('dos CartItems con cantidades diferentes no deben ser iguales', () {
      const item1 = CartItem(product: testProduct, quantity: 2);
      const item2 = CartItem(product: testProduct, quantity: 3);

      expect(item1, isNot(equals(item2)));
    });
  });

  group('Product', () {
    test('dos Products con mismos valores deben ser iguales', () {
      const product1 = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img',
        rating: ProductRating(rate: 4.0, count: 10),
      );
      const product2 = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img',
        rating: ProductRating(rate: 4.0, count: 10),
      );

      expect(product1, equals(product2));
    });
  });

  group('ProductRating', () {
    test('dos ProductRatings con mismos valores deben ser iguales', () {
      const rating1 = ProductRating(rate: 4.5, count: 100);
      const rating2 = ProductRating(rate: 4.5, count: 100);

      expect(rating1, equals(rating2));
    });

    test('dos ProductRatings con valores diferentes no deben ser iguales', () {
      const rating1 = ProductRating(rate: 4.5, count: 100);
      const rating2 = ProductRating(rate: 3.5, count: 100);

      expect(rating1, isNot(equals(rating2)));
    });
  });
}

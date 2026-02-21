import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/domain/usecases/add_to_cart.dart';
import 'package:carrito_compras/features/cart/domain/usecases/clear_cart.dart';
import 'package:carrito_compras/features/cart/domain/usecases/get_cart_items.dart';
import 'package:carrito_compras/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:carrito_compras/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_event.dart';
import 'package:carrito_compras/features/cart/presentation/bloc/cart_state.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';

class MockGetCartItems extends Mock implements GetCartItems {}

class MockAddToCart extends Mock implements AddToCart {}

class MockRemoveFromCart extends Mock implements RemoveFromCart {}

class MockUpdateCartQuantity extends Mock implements UpdateCartQuantity {}

class MockClearCart extends Mock implements ClearCart {}

void main() {
  late CartBloc cartBloc;
  late MockGetCartItems mockGetCartItems;
  late MockAddToCart mockAddToCart;
  late MockRemoveFromCart mockRemoveFromCart;
  late MockUpdateCartQuantity mockUpdateCartQuantity;
  late MockClearCart mockClearCart;

  setUp(() {
    mockGetCartItems = MockGetCartItems();
    mockAddToCart = MockAddToCart();
    mockRemoveFromCart = MockRemoveFromCart();
    mockUpdateCartQuantity = MockUpdateCartQuantity();
    mockClearCart = MockClearCart();

    cartBloc = CartBloc(
      getCartItems: mockGetCartItems,
      addToCart: mockAddToCart,
      removeFromCart: mockRemoveFromCart,
      updateCartQuantity: mockUpdateCartQuantity,
      clearCart: mockClearCart,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  const testProduct = Product(
    id: 1,
    title: 'Test Product',
    price: 10.0,
    description: 'Test description',
    category: 'test',
    image: 'https://example.com/image.jpg',
    rating: ProductRating(rate: 4.5, count: 100),
  );

  const testCartItem = CartItem(product: testProduct, quantity: 1);
  final testCartItems = [testCartItem];

  group('CartBloc', () {
    test('el estado inicial es CartInitial', () {
      expect(cartBloc.state, const CartInitial());
    });

    group('LoadCart', () {
      blocTest<CartBloc, CartState>(
        'emite [CartLoading, CartLoaded] cuando LoadCart es exitoso',
        build: () {
          when(
            () => mockGetCartItems(NoParams()),
          ).thenAnswer((_) async => Right(testCartItems));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [const CartLoading(), CartLoaded(items: testCartItems)],
        verify: (_) {
          verify(() => mockGetCartItems(NoParams())).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emite [CartLoading, CartError] cuando LoadCart falla',
        build: () {
          when(
            () => mockGetCartItems(NoParams()),
          ).thenAnswer((_) async => const Left(CacheFailure(message: 'Error')));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [const CartLoading(), const CartError('Error')],
      );
    });

    group('AddProductToCart', () {
      blocTest<CartBloc, CartState>(
        'emite [CartLoaded] cuando AddProductToCart es exitoso',
        build: () {
          when(
            () => mockAddToCart(testProduct),
          ).thenAnswer((_) async => Right(testCartItems));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const AddProductToCart(testProduct)),
        expect: () => [CartLoaded(items: testCartItems)],
        verify: (_) {
          verify(() => mockAddToCart(testProduct)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emite [CartError] cuando AddProductToCart falla',
        build: () {
          when(() => mockAddToCart(testProduct)).thenAnswer(
            (_) async => const Left(CacheFailure(message: 'Error adding')),
          );
          return cartBloc;
        },
        act: (bloc) => bloc.add(const AddProductToCart(testProduct)),
        expect: () => [const CartError('Error adding')],
      );
    });

    group('RemoveProductFromCart', () {
      blocTest<CartBloc, CartState>(
        'emite [CartLoaded] con lista vacía cuando RemoveProductFromCart es exitoso',
        build: () {
          when(
            () => mockRemoveFromCart(1),
          ).thenAnswer((_) async => const Right([]));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const RemoveProductFromCart(1)),
        expect: () => [const CartLoaded(items: [])],
        verify: (_) {
          verify(() => mockRemoveFromCart(1)).called(1);
        },
      );
    });

    group('ClearCartEvent', () {
      blocTest<CartBloc, CartState>(
        'emite [CartLoaded] con items vacíos cuando ClearCartEvent es exitoso',
        build: () {
          when(
            () => mockClearCart(NoParams()),
          ).thenAnswer((_) async => const Right(null));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const ClearCartEvent()),
        expect: () => [const CartLoaded(items: [])],
        verify: (_) {
          verify(() => mockClearCart(NoParams())).called(1);
        },
      );
    });
  });

  group('Estado CartLoaded', () {
    test('totalItems retorna la suma de cantidades', () {
      const item1 = CartItem(product: testProduct, quantity: 2);
      const item2 = CartItem(
        product: Product(
          id: 2,
          title: 'Product 2',
          price: 20.0,
          description: 'Desc',
          category: 'cat',
          image: 'img',
          rating: ProductRating(rate: 4, count: 50),
        ),
        quantity: 3,
      );
      const state = CartLoaded(items: [item1, item2]);

      expect(state.totalItems, 5);
    });

    test('totalPrice retorna la suma de subtotales', () {
      const item1 = CartItem(product: testProduct, quantity: 2);
      const item2 = CartItem(
        product: Product(
          id: 2,
          title: 'Product 2',
          price: 15.0,
          description: 'Desc',
          category: 'cat',
          image: 'img',
          rating: ProductRating(rate: 4, count: 50),
        ),
        quantity: 3,
      );
      const state = CartLoaded(items: [item1, item2]);

      expect(state.totalPrice, 65.0);
    });

    test('isEmpty retorna true para carrito vacío', () {
      const state = CartLoaded(items: []);
      expect(state.isEmpty, true);
    });

    test('isEmpty retorna false para carrito con items', () {
      const state = CartLoaded(items: [testCartItem]);
      expect(state.isEmpty, false);
    });

    test('containsProduct retorna true cuando el producto existe', () {
      const state = CartLoaded(items: [testCartItem]);
      expect(state.containsProduct(1), true);
    });

    test('containsProduct retorna false cuando el producto no existe', () {
      const state = CartLoaded(items: [testCartItem]);
      expect(state.containsProduct(999), false);
    });

    test('getQuantityForProduct retorna la cantidad correcta', () {
      const item = CartItem(product: testProduct, quantity: 3);
      const state = CartLoaded(items: [item]);
      expect(state.getQuantityForProduct(1), 3);
    });

    test('getQuantityForProduct retorna 0 para producto inexistente', () {
      const state = CartLoaded(items: [testCartItem]);
      expect(state.getQuantityForProduct(999), 0);
    });
  });
}

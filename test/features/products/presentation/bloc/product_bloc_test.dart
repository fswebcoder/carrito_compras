import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:carrito_compras/features/products/domain/usecases/get_products.dart';
import 'package:carrito_compras/features/products/presentation/bloc/product_bloc.dart';
import 'package:carrito_compras/features/products/presentation/bloc/product_event.dart';
import 'package:carrito_compras/features/products/presentation/bloc/product_state.dart';

// Mocks
class MockGetProducts extends Mock implements GetProducts {}

void main() {
  late ProductBloc productBloc;
  late MockGetProducts mockGetProducts;

  setUp(() {
    mockGetProducts = MockGetProducts();
    productBloc = ProductBloc(getProducts: mockGetProducts);
  });

  tearDown(() {
    productBloc.close();
  });

  const testProducts = [
    Product(
      id: 1,
      title: 'Product 1',
      price: 10.0,
      description: 'Description 1',
      category: 'electronics',
      image: 'https://example.com/1.jpg',
      rating: ProductRating(rate: 4.5, count: 100),
    ),
    Product(
      id: 2,
      title: 'Product 2',
      price: 20.0,
      description: 'Description 2',
      category: 'clothing',
      image: 'https://example.com/2.jpg',
      rating: ProductRating(rate: 3.5, count: 50),
    ),
  ];

  group('ProductBloc', () {
    test('el estado inicial es ProductInitial', () {
      expect(productBloc.state, const ProductInitial());
    });

    group('LoadProducts', () {
      blocTest<ProductBloc, ProductState>(
        'emite [ProductLoading, ProductLoaded] cuando LoadProducts es exitoso',
        build: () {
          when(
            () => mockGetProducts(NoParams()),
          ).thenAnswer((_) async => const Right(testProducts));
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductLoading(),
          const ProductLoaded(products: testProducts),
        ],
        verify: (_) {
          verify(() => mockGetProducts(NoParams())).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'emite [ProductLoading, ProductError] cuando LoadProducts falla',
        build: () {
          when(() => mockGetProducts(NoParams())).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Error del servidor')),
          );
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductLoading(),
          const ProductError('Error del servidor'),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'emite [ProductLoading, ProductLoaded] con lista vacía cuando no hay productos',
        build: () {
          when(
            () => mockGetProducts(NoParams()),
          ).thenAnswer((_) async => const Right([]));
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductLoading(),
          const ProductLoaded(products: []),
        ],
      );
    });

    group('FilterByCategory', () {
      blocTest<ProductBloc, ProductState>(
        'emite productos filtrados cuando FilterByCategory es llamado',
        build: () {
          when(
            () => mockGetProducts(NoParams()),
          ).thenAnswer((_) async => const Right(testProducts));
          return productBloc;
        },
        act: (bloc) => bloc.add(const FilterByCategory('electronics')),
        expect: () => [
          const ProductLoading(),
          ProductLoaded(
            products: [testProducts[0]],
            selectedCategory: 'electronics',
          ),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'emite todos los productos cuando FilterByCategory es llamado con null',
        build: () {
          when(
            () => mockGetProducts(NoParams()),
          ).thenAnswer((_) async => const Right(testProducts));
          return productBloc;
        },
        act: (bloc) => bloc.add(const FilterByCategory(null)),
        expect: () => [
          const ProductLoading(),
          const ProductLoaded(products: testProducts),
        ],
      );
    });

    group('RefreshProducts', () {
      blocTest<ProductBloc, ProductState>(
        'emite [ProductLoaded] cuando RefreshProducts es exitoso',
        build: () {
          when(
            () => mockGetProducts(NoParams()),
          ).thenAnswer((_) async => const Right(testProducts));
          return productBloc;
        },
        seed: () => const ProductLoaded(products: []),
        act: (bloc) => bloc.add(const RefreshProducts()),
        expect: () => [const ProductLoaded(products: testProducts)],
      );
    });
  });
}

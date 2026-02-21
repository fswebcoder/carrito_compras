import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/products/domain/usecases/get_products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;

  ProductBloc({required this.getProducts}) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await getProducts(NoParams());

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) {
        emit(ProductLoaded(products: products));
      },
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    final result = await getProducts(NoParams());

    result.fold(
      (failure) {
        if (currentState is ProductLoaded) {
          emit(currentState);
        } else {
          emit(ProductError(failure.message));
        }
      },
      (products) {
        final selectedCategory = currentState is ProductLoaded
            ? currentState.selectedCategory
            : null;

        if (selectedCategory != null) {
          final filteredProducts = products
              .where(
                (p) =>
                    p.category.toLowerCase() == selectedCategory.toLowerCase(),
              )
              .toList();
          emit(
            ProductLoaded(
              products: filteredProducts,
              selectedCategory: selectedCategory,
            ),
          );
        } else {
          emit(ProductLoaded(products: products));
        }
      },
    );
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await getProducts(NoParams());

    result.fold((failure) => emit(ProductError(failure.message)), (products) {
      if (event.category == null) {
        emit(ProductLoaded(products: products));
      } else {
        final filteredProducts = products
            .where(
              (p) => p.category.toLowerCase() == event.category!.toLowerCase(),
            )
            .toList();
        emit(
          ProductLoaded(
            products: filteredProducts,
            selectedCategory: event.category,
          ),
        );
      }
    });
  }
}

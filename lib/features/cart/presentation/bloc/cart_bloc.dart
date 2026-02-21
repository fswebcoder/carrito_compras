import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/usecases/add_to_cart.dart';
import 'package:carrito_compras/features/cart/domain/usecases/clear_cart.dart';
import 'package:carrito_compras/features/cart/domain/usecases/get_cart_items.dart';
import 'package:carrito_compras/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:carrito_compras/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final UpdateCartQuantity updateCartQuantity;
  final ClearCart clearCart;

  CartBloc({
    required this.getCartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartQuantity,
    required this.clearCart,
  }) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());

    final result = await getCartItems(NoParams());

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items: items)),
    );
  }

  Future<void> _onAddProductToCart(
    AddProductToCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await addToCart(event.product);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items: items)),
    );
  }

  Future<void> _onRemoveProductFromCart(
    RemoveProductFromCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await removeFromCart(event.productId);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items: items)),
    );
  }

  Future<void> _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final currentItem = currentState.items
        .where((item) => item.product.id == event.productId)
        .firstOrNull;

    if (currentItem == null) return;

    final result = await updateCartQuantity(
      UpdateQuantityParams(
        productId: event.productId,
        quantity: currentItem.quantity + 1,
      ),
    );

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items: items)),
    );
  }

  Future<void> _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final currentItem = currentState.items
        .where((item) => item.product.id == event.productId)
        .firstOrNull;

    if (currentItem == null) return;

    if (currentItem.quantity <= 1) {
      final result = await removeFromCart(event.productId);
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (items) => emit(CartLoaded(items: items)),
      );
    } else {
      final result = await updateCartQuantity(
        UpdateQuantityParams(
          productId: event.productId,
          quantity: currentItem.quantity - 1,
        ),
      );
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (items) => emit(CartLoaded(items: items)),
      );
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await clearCart(NoParams());

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded(items: [])),
    );
  }
}

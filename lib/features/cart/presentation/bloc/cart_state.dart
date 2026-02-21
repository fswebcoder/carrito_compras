import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => items.isEmpty;

  int getQuantityForProduct(int productId) {
    final item = items
        .where((item) => item.product.id == productId)
        .firstOrNull;
    return item?.quantity ?? 0;
  }

  bool containsProduct(int productId) {
    return items.any((item) => item.product.id == productId);
  }

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

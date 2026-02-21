import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddProductToCart extends CartEvent {
  final Product product;

  const AddProductToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveProductFromCart extends CartEvent {
  final int productId;

  const RemoveProductFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class IncreaseQuantity extends CartEvent {
  final int productId;

  const IncreaseQuantity(this.productId);

  @override
  List<Object> get props => [productId];
}

class DecreaseQuantity extends CartEvent {
  final int productId;

  const DecreaseQuantity(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

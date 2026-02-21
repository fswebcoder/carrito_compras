import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/products/data/models/product_model.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';

class CartItemModel extends CartItem {
  const CartItemModel({required super.product, required super.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final productModel = product is ProductModel
        ? product as ProductModel
        : ProductModel.fromEntity(product);
    return {'product': productModel.toJson(), 'quantity': quantity};
  }

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(product: item.product, quantity: item.quantity);
  }

  @override
  CartItemModel copyWith({Product? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

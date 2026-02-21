import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();

  Future<Either<Failure, List<CartItem>>> addToCart(Product product);

  Future<Either<Failure, List<CartItem>>> removeFromCart(int productId);

  Future<Either<Failure, List<CartItem>>> updateQuantity(
    int productId,
    int quantity,
  );

  Future<Either<Failure, void>> clearCart();

  Future<Either<Failure, void>> saveCart(List<CartItem> items);

  Future<Either<Failure, List<CartItem>>> loadCart();
}

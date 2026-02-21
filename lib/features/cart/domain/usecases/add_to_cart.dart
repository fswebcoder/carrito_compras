import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/domain/repositories/cart_repository.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

class AddToCart implements UseCase<List<CartItem>, Product> {
  final CartRepository repository;

  AddToCart(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(Product product) async {
    return await repository.addToCart(product);
  }
}

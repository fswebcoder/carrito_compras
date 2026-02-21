import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/domain/repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveFromCart implements UseCase<List<CartItem>, int> {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(int productId) async {
    return await repository.removeFromCart(productId);
  }
}

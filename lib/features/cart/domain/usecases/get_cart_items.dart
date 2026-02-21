import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/domain/repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';

class GetCartItems implements UseCase<List<CartItem>, NoParams> {
  final CartRepository repository;

  GetCartItems(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) async {
    return await repository.getCartItems();
  }
}

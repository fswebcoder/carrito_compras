import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';

class ClearCart implements UseCase<void, NoParams> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearCart();
  }
}

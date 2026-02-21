import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/domain/repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateCartQuantity
    implements UseCase<List<CartItem>, UpdateQuantityParams> {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(
    UpdateQuantityParams params,
  ) async {
    return await repository.updateQuantity(params.productId, params.quantity);
  }
}

class UpdateQuantityParams extends Equatable {
  final int productId;
  final int quantity;

  const UpdateQuantityParams({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

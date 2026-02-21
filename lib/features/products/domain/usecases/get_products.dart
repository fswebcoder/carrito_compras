import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/usecases/usecase.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:carrito_compras/features/products/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}

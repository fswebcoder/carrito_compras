import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();

  Future<Either<Failure, Product>> getProductById(int id);

  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);

  Future<Either<Failure, List<String>>> getCategories();
}

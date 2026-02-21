import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/core/error/repository_mixin.dart';
import 'package:carrito_compras/features/products/data/datasources/product_remote_datasource.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:carrito_compras/features/products/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl with RepositoryMixin implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() {
    return safeCall(() => remoteDataSource.getProducts());
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) {
    return safeCall(() => remoteDataSource.getProductById(id));
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) {
    return safeCall(() => remoteDataSource.getProductsByCategory(category));
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() {
    return safeCall(() => remoteDataSource.getCategories());
  }
}

import 'package:carrito_compras/core/error/exceptions.dart';
import 'package:carrito_compras/core/error/failures.dart';
import 'package:dartz/dartz.dart';

mixin RepositoryMixin {
  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }
}

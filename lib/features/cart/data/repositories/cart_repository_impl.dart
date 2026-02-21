import 'package:carrito_compras/core/error/exceptions.dart';
import 'package:carrito_compras/core/error/failures.dart';
import 'package:carrito_compras/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:carrito_compras/features/cart/data/models/cart_item_model.dart';
import 'package:carrito_compras/features/cart/domain/entities/cart_item.dart';
import 'package:carrito_compras/features/cart/domain/repositories/cart_repository.dart';
import 'package:carrito_compras/features/products/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  List<CartItemModel> _cartItems = [];
  bool _isInitialized = false;

  CartRepositoryImpl({required this.localDataSource});

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        _cartItems = await localDataSource.getCartItems();
        _isInitialized = true;
      } catch (e) {
        _cartItems = [];
        _isInitialized = true;
      }
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      await _ensureInitialized();
      return Right(List.unmodifiable(_cartItems));
    } catch (e) {
      return Left(CacheFailure(message: 'Error al obtener el carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addToCart(Product product) async {
    try {
      await _ensureInitialized();

      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex != -1) {
        final existingItem = _cartItems[existingIndex];
        _cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        _cartItems.add(CartItemModel(product: product, quantity: 1));
      }

      await _saveToLocal();
      return Right(List.unmodifiable(_cartItems));
    } catch (e) {
      return Left(CacheFailure(message: 'Error al agregar al carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> removeFromCart(int productId) async {
    try {
      await _ensureInitialized();

      _cartItems.removeWhere((item) => item.product.id == productId);

      await _saveToLocal();
      return Right(List.unmodifiable(_cartItems));
    } catch (e) {
      return Left(CacheFailure(message: 'Error al eliminar del carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> updateQuantity(
    int productId,
    int quantity,
  ) async {
    try {
      await _ensureInitialized();

      if (quantity <= 0) {
        return removeFromCart(productId);
      }

      final index = _cartItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index != -1) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
        await _saveToLocal();
      }

      return Right(List.unmodifiable(_cartItems));
    } catch (e) {
      return Left(CacheFailure(message: 'Error al actualizar cantidad: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      _cartItems.clear();
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al limpiar el carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCart(List<CartItem> items) async {
    try {
      _cartItems = items.map((item) => CartItemModel.fromEntity(item)).toList();
      await _saveToLocal();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al guardar el carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> loadCart() async {
    try {
      _cartItems = await localDataSource.getCartItems();
      _isInitialized = true;
      return Right(List.unmodifiable(_cartItems));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Error al cargar el carrito: $e'));
    }
  }

  Future<void> _saveToLocal() async {
    await localDataSource.saveCartItems(_cartItems);
  }
}

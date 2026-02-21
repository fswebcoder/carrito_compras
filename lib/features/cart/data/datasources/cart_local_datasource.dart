import 'dart:convert';
import 'package:carrito_compras/core/error/exceptions.dart';
import 'package:carrito_compras/features/cart/data/models/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();

  Future<void> saveCartItems(List<CartItemModel> items);

  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cartKey = 'CART_ITEMS';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(cartKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CartItemModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Error al cargar el carrito: $e');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(cartKey, jsonString);
    } catch (e) {
      throw CacheException('Error al guardar el carrito: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await sharedPreferences.remove(cartKey);
    } catch (e) {
      throw CacheException('Error al limpiar el carrito: $e');
    }
  }
}

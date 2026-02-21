import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProductById(int id);

  Future<List<ProductModel>> getProductsByCategory(String category);

  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}';

      final response = await client
          .get(Uri.parse(url))
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Error al obtener productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error de conexión: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id',
            ),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        return ProductModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
          'Error al obtener producto: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error de conexión: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/category/$category',
            ),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Error al obtener productos por categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error de conexión: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/categories',
            ),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => e.toString()).toList();
      } else {
        throw ServerException(
          'Error al obtener categorías: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error de conexión: $e');
    }
  }
}

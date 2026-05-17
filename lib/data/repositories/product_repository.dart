import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopsmart/data/models/produt_model.dart';

class ProductRepository {
  // In-memory cache to improve performance and reduce API calls
  List<ProductModel>? _cachedProducts;
  DateTime? _lastFetchTime;
  static const _cacheDuration = Duration(minutes: 10);

  Future<List<ProductModel>> fetchProducts({bool forceRefresh = false}) async {
    // Return cached products if they exist and are not expired
    if (!forceRefresh && _cachedProducts != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        return _cachedProducts!;
      }
    }

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _cachedProducts = data.map((json) => ProductModel.fromJson(json)).toList();
        _lastFetchTime = DateTime.now();
        return _cachedProducts!;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to cache if network fails, even if expired
      if (_cachedProducts != null) return _cachedProducts!;
      rethrow;
    }
  }
}

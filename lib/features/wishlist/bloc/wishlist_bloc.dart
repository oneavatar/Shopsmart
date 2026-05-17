import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsmart/data/models/produt_model.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_event.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  static const String wishlistKey = "wishlist_items";

  WishlistBloc() : super(WishlistState(wishlist: [])) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistData = prefs.getString(wishlistKey);
      if (wishlistData != null) {
        final List<dynamic> decoded = jsonDecode(wishlistData);
        final items = decoded.map((item) => ProductModel.fromJson(item)).toList();
        emit(WishlistState(wishlist: items));
      }
    } catch (e) {
      print("Error loading wishlist: $e");
    }
  }

  Future<void> _onToggleWishlist(ToggleWishlist event, Emitter<WishlistState> emit) async {
    final items = List<ProductModel>.from(state.wishlist);
    final exists = items.any((item) => item.id == event.product.id);

    if (exists) {
      items.removeWhere((item) => item.id == event.product.id);
    } else {
      items.add(event.product);
    }

    emit(WishlistState(wishlist: items));
    await _saveWishlist(items);
  }

  Future<void> _saveWishlist(List<ProductModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistData = jsonEncode(items.map((item) => item.toJson()).toList());
      await prefs.setString(wishlistKey, wishlistData);
    } catch (e) {
      print("Error saving wishlist: $e");
    }
  }
}

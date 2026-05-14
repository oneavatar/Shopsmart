import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopsmart/core/services/interstitial_ad_service.dart';

import 'package:shopsmart/data/models/produt_model.dart';

import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';

import 'package:shopsmart/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_event.dart';
import 'package:shopsmart/features/wishlist/bloc/wishlist_state.dart';

import 'package:shopsmart/presentation/screens/product_detail_screen.dart';

class ProductCart extends StatelessWidget {
  final ProductModel product;
  final String heroTagPrefix;

  const ProductCart({super.key, required this.product, this.heroTagPrefix = ''});

  @override
  Widget build(BuildContext context) {
    final String heroTag = "$heroTagPrefix${product.id}_${product.title}";
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product, heroTag: heroTag),
          ),
        );
      },

      child: Card(
        elevation: 3,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Align(
                alignment: Alignment.topRight,

                child: BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    final isWishlisted = state.wishlist.any(
                      (item) => item.id == product.id,
                    );

                    return IconButton(
                      onPressed: () {
                        context.read<WishlistBloc>().add(
                          ToggleWishlist(product),
                        );
                      },

                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,

                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: Center(
                  child: Hero(
                    tag: heroTag,
                    child: Image.network(
                      product.imageUrl,

                      fit: BoxFit.contain,

                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

                        return const Center(child: CircularProgressIndicator());
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 50);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                product.title,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,

                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "\$${product.price}",

                style: const TextStyle(
                  color: Colors.green,

                  fontWeight: FontWeight.bold,

                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(product));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to cart")),
                    );

                    InterstitialAdService().showAd();
                  },

                  child: const Text("Add to Cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

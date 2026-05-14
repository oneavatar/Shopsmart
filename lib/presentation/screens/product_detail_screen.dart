import 'package:flutter/material.dart';
import 'package:shopsmart/data/models/produt_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final String heroTag;

  const ProductDetailScreen({super.key, required this.product, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Center(
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    product.imageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 20),
              Text(product.description, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

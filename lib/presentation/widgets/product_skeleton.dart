import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

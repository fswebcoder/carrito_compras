import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductsShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const ProductsShimmerGrid({
    super.key,
    this.itemCount = 8,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFE0F2F1),
          highlightColor: const Color(0xFFF5FAFA),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

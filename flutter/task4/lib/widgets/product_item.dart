import 'package:flutter/material.dart';
import '../models/product.dart';


class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        // Leading Icon
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.blue),
        ),

        // Title
        title: Text(
          product.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),

        // Subtitle
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "Premium product",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 14,
            ),
          ),
        ),

        // Price
        trailing: Text(
          "₹${product.price.toStringAsFixed(0)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
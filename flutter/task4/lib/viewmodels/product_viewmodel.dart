import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repo = ProductRepository();

  List<Product> products = [];

  int _page = 1;
  final int _limit = 20;

  bool isLoading = false;
  bool hasMore = true;

  Future<void> loadInitial() async {
    _page = 1;
    products.clear();
    hasMore = true;
    await _fetchProducts();
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    _page++;
    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    isLoading = true;
    notifyListeners();

    final newItems = await _repo.fetchProducts(_page, _limit);

    if (newItems.isEmpty) {
      hasMore = false;
    } else {
      products.addAll(newItems);
    }

    isLoading = false;
    notifyListeners();
  }
}
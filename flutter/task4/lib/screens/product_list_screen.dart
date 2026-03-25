import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final vm = context.read<ProductViewModel>();
    vm.loadInitial();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        vm.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: vm.products.length + 1,
        itemBuilder: (context, index) {
          if (index < vm.products.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProductItem(product: vm.products[index]),
            );
          } else {
            return vm.hasMore
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox();
          }
        },
      ),
    );
  }
}
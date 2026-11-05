import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge(
        label: Text('$count'),
        child: const Icon(Icons.shopping_cart),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/cart'),
    );
  }
}
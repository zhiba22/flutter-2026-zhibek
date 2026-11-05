import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, _) => ListView(
                children: [
                  for (final b in cart.items)
                    ListTile(
                      title: Text(b.title),
                      subtitle: Text('${b.price} ₸'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('×${cart.qtyOf(b)}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => cart.increment(b),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => cart.remove(b),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  child!,
                  const Spacer(),
                  Text('Total: ${cart.total} ₸'),
                ],
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined),
                SizedBox(width: 8),
                Text('Your order'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
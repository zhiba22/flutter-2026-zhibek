import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: const [CartBadge()],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, i) {
          final b = books[i];
          debugPrint('row ${b.title}');
          final inCart = context.select<Cart, bool>(
            (c) => c.items.contains(b),
          );
          return ListTile(
            title: Text(b.title),
            subtitle: Text(b.author),
            trailing: inCart
                ? const Text('Added')
                : OutlinedButton(
                    onPressed: () => context.read<Cart>().add(b),
                    child: const Text('Add'),
                  ),
          );
        },
      ),
    );
  }
}
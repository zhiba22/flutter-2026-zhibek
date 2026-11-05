import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');
    final shown = books
        .where((b) => b.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search books',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        actions: const [CartBadge()],
      ),
      body: ListView.builder(
        itemCount: shown.length,
        itemBuilder: (context, i) {
          final b = shown[i];
          return Builder(
            builder: (context) {
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
                        onPressed: () {
                          final ok = context.read<Cart>().add(b);
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added')),
                            );
                          }
                        },
                        child: const Text('Add'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

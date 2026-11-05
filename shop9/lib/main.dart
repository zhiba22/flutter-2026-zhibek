import 'package:flutter/material.dart';

import 'books_screen.dart';
import 'cart_screen.dart';
import 'models/book.dart';

void main() => runApp(const Shell());

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final List<Book> _cart = [];

  void _add(Book b) => setState(() => _cart.add(b));
  void _remove(Book b) => setState(() => _cart.remove(b));

  int get _total => _cart.fold(0, (sum, b) => sum + b.price);

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        routes: {
          '/': (_) => BooksScreen(cart: _cart, total: _total, onAdd: _add),
          '/cart': (_) => CartScreen(items: _cart, onRemove: _remove),
        },
      );
}
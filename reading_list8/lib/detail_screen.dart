import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;
    Navigator.of(context).pop(BookAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Book details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(book.title, style: text.headlineSmall),
          const SizedBox(height: 16),
          Text('Author: ${book.author}', style: text.bodyLarge),
          const SizedBox(height: 8),
          Text('Pages: ${book.pages}', style: text.bodyLarge),
          const SizedBox(height: 8),
          Text(
            book.year == null ? 'Year unknown' : 'Year: ${book.year}',
            style: text.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            book.read ? 'Status: read' : 'Status: unread',
            style: text.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(BookAction.toggleRead),
            child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _confirmDelete(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

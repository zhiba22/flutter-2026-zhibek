import 'models.dart';

sealed class ShelfState {
  const ShelfState();
}

class Empty extends ShelfState {
  const Empty();
}

class Ready extends ShelfState {
  final List<Book> books;
  const Ready(this.books);
}

class Broken extends ShelfState {
  final String message;
  const Broken(this.message);
}

String describe(ShelfState state) => switch (state) {
  Empty() => 'Shelf is empty',
  Ready(books: final list) => 'Shelf is ready: ${list.length} book(s)',
  Broken(message: final text) => 'Shelf is broken: $text',
};

({int count, double avgPages}) statsOf(List<Book> books) => (
  count: books.length,
  avgPages: books.isEmpty
      ? 0.0
      : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length,
);
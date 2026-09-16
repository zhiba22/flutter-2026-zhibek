import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) => items.add(item);

  void open() {
    openedAt = DateTime.now();
  }


// level-3 
  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  String report() {

    final cached = _cachedReport ??= display.join('\n');
    return cached;
  }

// level-4
  List<Book> get books => items.whereType<Book>().toList();

  List<String> get allTitles => items.map((item) => item.title).toList();

  List<Book> get publishedAfter2010 =>
      books.where((book) => book.year > 2010).toList();

  double get averagePages => books.isEmpty
      ? 0.0
      : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length;

  Map<String, int> get booksPerAuthor => books.fold<Map<String, int>>(
    <String, int>{},
    (acc, book) =>
        acc..update(book.author.name, (count) => count + 1, ifAbsent: () => 1),
  );

  Set<String> get authorNames => books.map((book) => book.author.name).toSet();

  Set<Genre> get genres => books.map((book) => book.genre).toSet();

  List<String> get display => [
    'CATALOGUE',
    for (final book in books) '${book.title} (${book.year})',
    ...authorNames,
    if (books.any((book) => book.pages == 0)) '(incomplete data)',
  ];
}
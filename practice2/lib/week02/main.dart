import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  library.open();

  for (final json in rawBooks) {
    library.add(Book.fromJson(json));
  }

  library.add(const Magazine(title: 'Dart Weekly', year: 2024, issue: 42));

  print(library.report());

  print('\n--- queries ---');
  print('All titles: ${library.allTitles}');
  print(
    'After 2010: ${library.publishedAfter2010.map((b) => b.title).toList()}',
  );
  print('Average pages: ${library.averagePages.toStringAsFixed(1)}');
  print('Books per author: ${library.booksPerAuthor}');
  print('Author names: ${library.authorNames}');
  print('Genres: ${library.genres.map((g) => g.label).toList()}');

  print('\n--- null safety ---');
  print('Country of "Refactoring": ${library.countryOf('Refactoring')}');
  print('Country of "Design Patterns": ${library.countryOf('Design Patterns')}');
  print('Missing book: ${library.findByTitle('No Such Book')}');
  print('Opened at: ${library.openedAt}');

  print('\n--- record ---');
  final stats = statsOf(library.books);
  print('count = ${stats.count}, avgPages = ${stats.avgPages.toStringAsFixed(1)}');

  print('\n--- shelf states ---');
  print(describe(const Empty()));
  print(describe(Ready(library.books)));
  print(describe(const Broken('water damage on the top row')));

  print('\n--- mixin & implements ---');
  print(library.books.first.borrowLabel());
  print(const Ghost(title: 'Lost Manuscript', year: 1900).describe());
}
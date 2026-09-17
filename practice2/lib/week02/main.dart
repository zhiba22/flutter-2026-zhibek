import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  library.open();

  for (var json in rawBooks) {
    var book = Book.fromJson(json);
    library.add(book);
  }

  var magazine = Magazine(title: 'Dart Weekly', year: 2024, issue: 42);
  library.add(magazine);

  print(library.report());

  // q
  print('');
  print('all titles:');
  print(library.allTitles);

  print('books after 2010:');
  print(library.publishedAfter2010);

  print('');
  print('average pages = ${library.averagePages}');

  print('books per author:');
  print(library.booksPerAuthor);

  print('author names:');
  print(library.authorNames);

  print('genres:');
  print(library.genres);

  // null
  print('');
  print('country of Refactoring = ${library.countryOf('Refactoring')}');
  print('country of Design Patterns = ${library.countryOf('Design Patterns')}');

  var missing = library.findByTitle('some book that doesnt exist');
  print('missing book = $missing');
  print('opened at = ${library.openedAt}');

  // 5
  var stats = statsOf(library.books);
  print('');
  print('stats: count=${stats.count} avg=${stats.avgPages}');

  // switch
  print('');
  print(describe(Empty()));
  print(describe(Ready(library.books)));
  print(describe(Broken('water damage on top shelf')));

  // mix
  print('');
  var firstBook = library.books[0];
  print(firstBook.borrowLabel());

  var ghost = Ghost(title: 'Lost Manuscript', year: 1900);
  print(ghost.describe());
}
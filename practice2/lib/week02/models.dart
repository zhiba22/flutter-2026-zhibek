class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() => 'Author($name, ${country ?? 'unknown'})';
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;
  const Genre(this.label);

  static Genre fromString(String? raw) {
    if (raw == 'craft') return Genre.craft;
    if (raw == 'theory') return Genre.theory;
    return Genre.unknown;
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  String describe();

  bool get isOld => year < 2000;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrow: "$title"';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var title = json['title'];
    var year = json['year'];
    var pages = json['pages'];
    var author = json['author'];
    var country = json['country'];
    var genre = json['genre'];
    var description = json['description'];

    return Book(
      title: title is String ? title : 'Untitled',
      year: year is int ? year : 0,
      pages: pages is int ? pages : 0,
      author: Author(
        name: author is String ? author : 'Unknown',
        country: country is String ? country : null,
      ),
      genre: Genre.fromString(genre is String ? genre : null),
      description: description is String ? description : null,
    );
  }

  bool get isLong => pages > 400;

  @override
  String describe() => '$title ($year) by ${author.name} - ${genre.label}';

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String toString() =>
      'Book($title, $year, $pages p., ${author.name}, ${genre.label})';
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() => '$title, issue #$issue ($year)';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({required this.title, required this.year});

  @override
  String describe() => 'Ghost entry "$title" - no data available';

  @override
  bool get isOld => true;
}
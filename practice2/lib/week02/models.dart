// level - 1
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

  static Genre fromString(String? raw) => switch (raw) {
    'craft' => Genre.craft,
    'theory' => Genre.theory,
    _ => Genre.unknown,
  };
}

// level - 2
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
    final title = switch (json['title']) {
      final String value => value,
      _ => 'Untitled',
    };
    final year = switch (json['year']) {
      final int value => value,
      _ => 0,
    };
    final pages = switch (json['pages']) {
      final int value => value,
      _ => 0,
    };
    final authorName = switch (json['author']) {
      final String value => value,
      _ => 'Unknown',
    };
    final country = switch (json['country']) {
      final String value => value,
      _ => null,
    };
    final rawGenre = switch (json['genre']) {
      final String value => value,
      _ => null,
    };
    final description = switch (json['description']) {
      final String value => value,
      _ => null,
    };

    return Book(
      title: title,
      year: year,
      pages: pages,
      author: Author(name: authorName, country: country),
      genre: Genre.fromString(rawGenre),
      description: description,
    );
  }

  bool get isLong => pages > 400;

  @override
  String describe() => '$title ($year) by ${author.name} — ${genre.label}';

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) => Book(
    title: title ?? this.title,
    year: year ?? this.year,
    pages: pages ?? this.pages,
    author: author ?? this.author,
    genre: genre ?? this.genre,
    description: description ?? this.description,
  );

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
  String describe() => 'Ghost entry "$title" — no data available';

  @override
  bool get isOld => true;
}
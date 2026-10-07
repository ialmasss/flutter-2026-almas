class Author {
  final String name;
  final String? country;

  const Author(this.name, {this.country});

  @override
  String toString() => country == null ? name : '$name ($country)';
}


enum Genre {
  craft('Craft & Practice'),
  theory('Theory & Design'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);


  static Genre fromString(String? raw) {
    switch (raw) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem(this.title, this.year);

  String describe();

  bool get isOld => DateTime.now().year - year > 25;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrow "$title" ($year)';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required String title,
    required int year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  }) : super(title, year);

  const Book.missing()
      : pages = 0,
        author = const Author('Unknown'),
        genre = Genre.unknown,
        description = null,
        super('Unknown title', 0);


  factory Book.fromJson(Map<String, dynamic> json) {
    final String title = json['title'] as String? ?? 'Unknown title';
    final int year = json['year'] as int? ?? 0;
    final int pages = json['pages'] as int? ?? 0;
    final String authorName = json['author'] as String? ?? 'Unknown';
    final String? country = json['country'] as String?;
    final Genre genre = Genre.fromString(json['genre'] as String?);
    final String? description = json['description'] as String?;

    return Book(
      title: title,
      year: year,
      pages: pages,
      author: Author(authorName, country: country),
      genre: genre,
      description: description,
    );
  }

  bool get isLong => pages > 400;

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
  String describe() => '$title ($year) -- ${genre.label}, by $author';

  @override
  String toString() =>
      'Book("$title", $year, ${pages}p, by $author, ${genre.label})';
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required String title,
    required int year,
    required this.issue,
  }) : super(title, year);

  @override
  String describe() => '$title #$issue ($year)';
}

class Ghost implements LibraryItem {
  @override
  final String title;
  @override
  final int year;

  const Ghost(this.title, this.year);

  @override
  String describe() => 'A ghost entry: "$title" ($year) -- details lost';

  @override
  bool get isOld => DateTime.now().year - year > 25;
}
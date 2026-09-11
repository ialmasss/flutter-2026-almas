import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  void add(LibraryItem item) => items.add(item);

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) return item;
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  late final DateTime openedAt;

  void open() => openedAt = DateTime.now();

  String? _cachedReport;

  String get report => _cachedReport ??= _buildReport();


  List<Book> get _books => items.whereType<Book>().toList();

  Iterable<String> get allTitles => _books.map((b) => b.title);

  Iterable<Book> get recentBooks => _books.where((b) => b.year > 2010);

  double get averagePages {
    final books = _books;
    if (books.isEmpty) return 0.0;
    return books.fold<int>(0, (sum, b) => sum + b.pages) / books.length;
  }

  Map<String, int> get booksPerAuthor => _books.fold<Map<String, int>>(
    {},
        (map, b) => map..update(b.author.name, (n) => n + 1, ifAbsent: () => 1),
  );

  Set<String> get authorNames => _books.map((b) => b.author.name).toSet();

  Set<Genre> get genresPresent => _books.map((b) => b.genre).toSet();

  String _buildReport() {
    final books = _books;
    final display = <String>[
      'CATALOGUE',
      for (final b in books) '${b.title} (${b.year})',
      ...authorNames,
      if (books.any((b) => b.pages == 0)) '(incomplete data)',
    ];
    return display.join('\n');
  }
}
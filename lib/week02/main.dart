// ignore_for_file: avoid_print

import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library()..open();

  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }

  print('Opened at: ${library.openedAt}');

  print('Queries:');
  print('All titles: ${library.allTitles.toList()}');
  print('Recent books (>2010): ${library.recentBooks.map((b) => b.title).toList()}');
  print('Average pages: ${library.averagePages.toStringAsFixed(1)}');
  print('Books per author: ${library.booksPerAuthor}');
  print('Author names: ${library.authorNames}');
  print('Genres present: ${library.genresPresent}');
  print("Country of 'Refactoring': ${library.countryOf('Refactoring')}");
  print("Country of 'Broken Record': ${library.countryOf('Broken Record')}");
  print("Country of 'Nonexistent': ${library.countryOf('Nonexistent')}");

  print('Report');
  print(library.report);

  final books = library.items.whereType<Book>().toList();
  final stats = statsOf(books);
  print('Stats record');
  print('count: ${stats.count}, avgPages: ${stats.avgPages.toStringAsFixed(1)}');

  print('Shelf states');
  print(describe(const Empty()));
  print(describe(Ready(books)));
  print(describe(const Broken('shelf collapsed')));
}
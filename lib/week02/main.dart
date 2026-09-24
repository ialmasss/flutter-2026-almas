<<<<<<< HEAD
// ignore_for_file: avoid_print

=======
>>>>>>> 8a90552f88f225da4b04a2503358380f9034f4a3
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

<<<<<<< HEAD
  print('Queries:');
  print('All titles: ${library.allTitles.toList()}');
  print('Recent books (>2010): ${library.recentBooks.map((b) => b.title).toList()}');
=======
  print('\n--- Queries ---');
  print('All titles: ${library.allTitles.toList()}');
  print(
      'Recent books (>2010): ${library.recentBooks.map((b) => b.title).toList()}');
>>>>>>> 8a90552f88f225da4b04a2503358380f9034f4a3
  print('Average pages: ${library.averagePages.toStringAsFixed(1)}');
  print('Books per author: ${library.booksPerAuthor}');
  print('Author names: ${library.authorNames}');
  print('Genres present: ${library.genresPresent}');
  print("Country of 'Refactoring': ${library.countryOf('Refactoring')}");
  print("Country of 'Broken Record': ${library.countryOf('Broken Record')}");
  print("Country of 'Nonexistent': ${library.countryOf('Nonexistent')}");

<<<<<<< HEAD
  print('Report');
=======
  print('\n--- Report ---');
>>>>>>> 8a90552f88f225da4b04a2503358380f9034f4a3
  print(library.report);

  final books = library.items.whereType<Book>().toList();
  final stats = statsOf(books);
<<<<<<< HEAD
  print('Stats record');
  print('count: ${stats.count}, avgPages: ${stats.avgPages.toStringAsFixed(1)}');

  print('Shelf states');
=======
  print('\n--- Stats record ---');
  print('count: ${stats.count}, avgPages: ${stats.avgPages.toStringAsFixed(1)}');

  print('\n--- Shelf states ---');
>>>>>>> 8a90552f88f225da4b04a2503358380f9034f4a3
  print(describe(const Empty()));
  print(describe(Ready(books)));
  print(describe(const Broken('shelf collapsed')));
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');
    final cartItems = context.watch<Cart>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: const [
          CartBadge(),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          debugPrint('row ${book.title}');
          final inCart = cartItems.contains(book);

          return ListTile(
            title: Text(book.title),
            subtitle: Text('${book.author} — ${book.price} ₸'),
            trailing: inCart
                ? const Text('Added', style: TextStyle(color: Colors.grey))
                : OutlinedButton(
              onPressed: () {
                final ok = context.read<Cart>().add(book);
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${book.title} added to cart!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Cart'),
                  content: const Text('Are you sure you want to clear the cart?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                context.read<Cart>().clear();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, _) {
                final items = cart.items;
                if (items.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final book = items[index];
                    final qty = cart.qtyOf(book);
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text('${book.price} ₸ × $qty = ${book.price * qty} ₸'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('×$qty'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => cart.increment(book),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => cart.remove(book),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.orange.shade50,
                child: Row(
                  children: [
                    child!,
                    const Spacer(),
                    Text(
                      '${cart.total} ₸',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 8),
                Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
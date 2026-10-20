import 'package:flutter/material.dart';
import '../models/item.dart';
import '../routes/routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/item_card.dart';

class FavoritesTab extends StatelessWidget {
  final List<Item> items;
  final ValueChanged<Item> onItemUpdated;
  final ValueChanged<String> onItemDeleted;

  const FavoritesTab({
    super.key,
    required this.items,
    required this.onItemUpdated,
    required this.onItemDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final favItems = items.where((i) => i.favourite).toList();

    if (favItems.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.favorite_border,
        message: 'No favourite events yet',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: favItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final item = favItems[index];
        return ItemCard(
          item: item,
          onToggleFavourite: onItemUpdated,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.detail,
              arguments: DetailArgs(
                item: item,
                onItemUpdated: onItemUpdated,
                onItemDeleted: onItemDeleted,
              ),
            );
          },
        );
      },
    );
  }
}
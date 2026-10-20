import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/format.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final ValueChanged<Item> onToggleFavourite;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onToggleFavourite,
    required this.onTap,
  });

  ColorSchemeRole _getCategoryRole(ItemCategory category) {
    return switch (category) {
      ItemCategory.tech => ColorSchemeRole.primary,
      ItemCategory.sports => ColorSchemeRole.secondary,
      ItemCategory.art => ColorSchemeRole.tertiary,
      ItemCategory.science => ColorSchemeRole.primaryContainer,
      ItemCategory.social => ColorSchemeRole.secondaryContainer,
    };
  }

  Color _getColorFromRole(BuildContext context, ColorSchemeRole role) {
    final scheme = Theme.of(context).colorScheme;
    return switch (role) {
      ColorSchemeRole.primary => scheme.primary,
      ColorSchemeRole.secondary => scheme.secondary,
      ColorSchemeRole.tertiary => scheme.tertiary,
      ColorSchemeRole.primaryContainer => scheme.primaryContainer,
      ColorSchemeRole.secondaryContainer => scheme.secondaryContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getColorFromRole(context, _getCategoryRole(item.category));

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: categoryColor.withAlpha(50),
                    child: Icon(item.category.icon, color: categoryColor),
                  ),
                  if (item.isFull)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'FULL',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else if (item.freePlaces <= 5)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${item.freePlaces} left',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${FormatUtils.formatDate(item.when)} • ${item.place}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  item.favourite ? Icons.favorite : Icons.favorite_border,
                  color: item.favourite ? Theme.of(context).colorScheme.error : null,
                ),
                onPressed: () => onToggleFavourite(item.copyWith(favourite: !item.favourite)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ColorSchemeRole { primary, secondary, tertiary, primaryContainer, secondaryContainer }
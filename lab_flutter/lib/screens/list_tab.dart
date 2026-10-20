import 'package:flutter/material.dart';
import '../models/item.dart';
import '../routes/routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/item_card.dart';

class ListTab extends StatefulWidget {
  final List<Item> items;
  final ValueChanged<Item> onItemUpdated;
  final ValueChanged<String> onItemDeleted;
  final ValueChanged<Item> onItemAdded;

  const ListTab({
    super.key,
    required this.items,
    required this.onItemUpdated,
    required this.onItemDeleted,
    required this.onItemAdded,
  });

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  final TextEditingController _searchController = TextEditingController();
  ItemCategory? _selectedCategory;
  bool _showPast = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> get _filteredItems {
    final query = _searchController.text.toLowerCase();
    var filtered = widget.items.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == null || item.category == _selectedCategory;
      final matchesPast = _showPast ? true : !item.isPast;
      return matchesSearch && matchesCategory && matchesPast;
    }).toList();

    filtered.sort((a, b) => a.when.compareTo(b.when));
    return filtered;
  }

  void _resetSearch() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _showPast = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _searchController.clear()),
              )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = null);
                },
              ),
              const SizedBox(width: 8),
              ...ItemCategory.values.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    avatar: Icon(cat.icon, size: 18),
                    label: Text(cat.label),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = selected ? cat : null);
                    },
                  ),
                );
              }),
              FilterChip(
                label: const Text('Show Past'),
                selected: _showPast,
                onSelected: (val) => setState(() => _showPast = val),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredList.isEmpty
              ? EmptyStateWidget(
            icon: Icons.search_off,
            message: 'No events match your criteria',
            buttonLabel: 'Reset filters',
            onButtonPressed: _resetSearch,
          )
              : LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return ItemCard(
                      item: item,
                      onToggleFavourite: widget.onItemUpdated,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.detail,
                          arguments: DetailArgs(
                            item: item,
                            onItemUpdated: widget.onItemUpdated,
                            onItemDeleted: widget.onItemDeleted,
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return ItemCard(
                      item: item,
                      onToggleFavourite: widget.onItemUpdated,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.detail,
                          arguments: DetailArgs(
                            item: item,
                            onItemUpdated: widget.onItemUpdated,
                            onItemDeleted: widget.onItemDeleted,
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
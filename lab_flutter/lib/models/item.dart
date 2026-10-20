import 'package:flutter/material.dart';

enum ItemCategory {
  tech('Tech', Icons.code),
  sports('Sports', Icons.sports_basketball),
  art('Art', Icons.brush),
  science('Science', Icons.science),
  social('Social', Icons.people);

  final String label;
  final IconData icon;
  const ItemCategory(this.label, this.icon);
}

@immutable
class Item {
  final String id;
  final String title;
  final ItemCategory category;
  final DateTime when;
  final int limit;
  final List<String> attendees;
  final bool mode; // true -> online (location is URL), false -> offline
  final String place;
  final String? description;
  final bool favourite;

  const Item({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required this.attendees,
    required this.mode,
    required this.place,
    this.description,
    this.favourite = false,
  });

  Item.empty()
      : id = '',
        title = '',
        category = ItemCategory.tech,
        when = DateTime.now().add(const Duration(days: 1)),
        limit = 20,
        attendees = const [],
        mode = false,
        place = '',
        description = null,
        favourite = false;

  int get count => attendees.length;
  int get freePlaces => limit - count;
  bool get isFull => count >= limit;
  bool get isPast => when.isBefore(DateTime.now());

  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  bool containsName(String name) => attendees.contains(name);

  Item copyWith({
    String? id,
    String? title,
    ItemCategory? category,
    DateTime? when,
    int? limit,
    List<String>? attendees,
    bool? mode,
    String? place,
    String? description,
    bool? favourite,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      attendees: attendees != null ? List.unmodifiable(attendees) : this.attendees,
      mode: mode ?? this.mode,
      place: place ?? this.place,
      description: description ?? this.description,
      favourite: favourite ?? this.favourite,
    );
  }
}
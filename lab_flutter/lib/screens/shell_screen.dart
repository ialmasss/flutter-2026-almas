import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/profile.dart';
import '../routes/routes.dart';
import '../widgets/app_drawer.dart';
import 'favorites_tab.dart';
import 'list_tab.dart';
import 'profile_tab.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;
  late Profile _profile;
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _profile = const Profile(name: 'Almas', group: 'CS-201');
    _items = _generateSeedData();
  }

  List<Item> _generateSeedData() {
    final now = DateTime.now();
    return [
      Item(
        id: '1',
        title: 'A Very Long Event Title That Reaches Exactly Sixty Characters!',
        category: ItemCategory.tech,
        when: now.add(const Duration(days: 2)),
        limit: 30,
        attendees: const ['Alice', 'Bob'],
        mode: false,
        place: 'Main Hall',
        description: 'Testing long text layout',
      ),
      Item(
        id: '2',
        title: 'Full Capacity Workshop',
        category: ItemCategory.science,
        when: now.add(const Duration(days: 3)),
        limit: 2,
        attendees: const ['Almas', 'Charlie'],
        mode: false,
        place: 'Room 101',
      ),
      Item(
        id: '3',
        title: 'Past Orientation Meetup',
        category: ItemCategory.social,
        when: now.subtract(const Duration(days: 5)),
        limit: 50,
        attendees: const ['Almas'],
        mode: false,
        place: 'Auditorium',
      ),
      Item(
        id: '4',
        title: 'Flutter Online Bootcamp',
        category: ItemCategory.tech,
        when: now.add(const Duration(days: 1)),
        limit: 100,
        attendees: const ['Dave'],
        mode: true,
        place: 'https://meet.google.com/abc-defg-hij',
      ),
      Item(
        id: '5',
        title: 'Simple Art Gallery Tour',
        category: ItemCategory.art,
        when: now.add(const Duration(days: 4)),
        limit: 15,
        attendees: const [],
        mode: false,
        place: 'Campus Center',
      ),
      Item(
        id: '6',
        title: 'Basketball Tournament',
        category: ItemCategory.sports,
        when: now.add(const Duration(hours: 5)),
        limit: 10,
        attendees: const ['Almas', 'Eve'],
        mode: false,
        place: 'Gymnasium',
      ),
      Item(
        id: '7',
        title: 'AI & ML Seminar',
        category: ItemCategory.tech,
        when: now.add(const Duration(days: 7)),
        limit: 40,
        attendees: const [],
        mode: false,
        place: 'Lab 3',
      ),
      Item(
        id: '8',
        title: 'Music Jam Session',
        category: ItemCategory.art,
        when: now.add(const Duration(days: 8)),
        limit: 20,
        attendees: const ['Frank'],
        mode: false,
        place: 'Music Room',
      ),
      Item(
        id: '9',
        title: 'Physics Lab Quiz',
        category: ItemCategory.science,
        when: now.add(const Duration(days: 10)),
        limit: 25,
        attendees: const [],
        mode: false,
        place: 'Science Block',
      ),
      Item(
        id: '10',
        title: 'Chess Club Championship',
        category: ItemCategory.sports,
        when: now.add(const Duration(days: 12)),
        limit: 16,
        attendees: const ['Grace'],
        mode: false,
        place: 'Student Lounge',
      ),
      Item(
        id: '11',
        title: 'Charity Food Drive',
        category: ItemCategory.social,
        when: now.add(const Duration(days: 14)),
        limit: 50,
        attendees: const [],
        mode: false,
        place: 'Central Square',
      ),
      Item(
        id: '12',
        title: 'Web Dev Basics',
        category: ItemCategory.tech,
        when: now.add(const Duration(days: 15)),
        limit: 30,
        attendees: const [],
        mode: true,
        place: 'https://zoom.us/j/123456789',
      ),
    ];
  }

  void _onItemUpdated(Item updated) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == updated.id);
      if (index != -1) {
        _items[index] = updated;
      }
    });
  }

  void _onItemDeleted(String id) {
    setState(() {
      _items.removeWhere((i) => i.id == id);
    });
  }

  void _onItemAdded(Item item) {
    setState(() {
      _items.add(item);
    });
  }

  void _resetData() {
    setState(() {
      _items = _generateSeedData();
      _profile = Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registeredCount = _items.where((i) => i.containsName(_profile.name)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
      ),
      drawer: AppDrawer(onResetData: _resetData),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListTab(
            items: _items,
            onItemUpdated: _onItemUpdated,
            onItemDeleted: _onItemDeleted,
            onItemAdded: _onItemAdded,
          ),
          FavoritesTab(
            items: _items,
            onItemUpdated: _onItemUpdated,
            onItemDeleted: _onItemDeleted,
          ),
          ProfileTab(
            profile: _profile,
            onProfileUpdated: (p) => setState(() => _profile = p),
            currentThemeMode: ThemeMode.system,
            onThemeModeChanged: (_) {},
            registeredEventsCount: registeredCount,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favourites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.pushNamed<Item>(context, Routes.form);
          if (newItem != null) {
            _onItemAdded(newItem);
          }
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
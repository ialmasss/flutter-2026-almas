import 'dart:async';
import 'package:flutter/material.dart';
import '../models/countdown.dart';
import '../models/item.dart';
import '../routes/routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class DetailScreen extends StatefulWidget {
  final Item item;
  final ValueChanged<Item> onItemUpdated;
  final ValueChanged<String> onItemDeleted;

  const DetailScreen({
    super.key,
    required this.item,
    required this.onItemUpdated,
    required this.onItemDeleted,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Item _item;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Countdown _getCountdown() {
    final now = DateTime.now();
    final diff = _item.when.difference(now);
    if (diff.isNegative) {
      return const CountdownEnded();
    } else if (diff.inHours < 1) {
      return CountdownStarted(diff);
    } else {
      return CountdownUpcoming(diff);
    }
  }

  Widget _buildCountdownWidget(Countdown countdown) {
    final text = switch (countdown) {
      CountdownUpcoming(:final remaining) => '${remaining.inHours}h ${remaining.inMinutes % 60}m left',
      CountdownStarted(:final elapsed) => 'Starts in ${elapsed.inMinutes}m',
      CountdownEnded() => 'Event ended',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  void _toggleRegistration() async {
    const userName = 'Almas'; // Current profile user
    final isOnList = _item.containsName(userName);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isOnList ? 'Unregister?' : 'Register for Event?'),
        content: Text(isOnList
            ? 'Do you want to remove yourself from ${_item.title}?'
            : 'Do you want to register for ${_item.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      List<String> newAttendees = List.from(_item.attendees);
      if (isOnList) {
        newAttendees.remove(userName);
      } else {
        newAttendees.add(userName);
      }
      final updated = _item.copyWith(attendees: newAttendees);
      setState(() => _item = updated);
      widget.onItemUpdated(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = _item.places;
    const userName = 'Almas';
    final isOnList = _item.containsName(userName);

    return Scaffold(
      appBar: AppBar(
        title: Text(_item.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) async {
              if (val == 'edit') {
                final updated = await Navigator.pushNamed<Item>(
                  context,
                  Routes.form,
                  arguments: _item,
                );
                if (updated != null && mounted) {
                  setState(() => _item = updated);
                  widget.onItemUpdated(updated);
                }
              } else if (val == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Event?'),
                    content: const Text('Are you sure you want to delete this event?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  widget.onItemDeleted(_item.id);
                  Navigator.pop(context);
                }
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Center(
                    child: Icon(_item.category.icon, size: 64),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Chip(
                    avatar: Icon(_item.category.icon, size: 16),
                    label: Text(_item.category.label),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: _buildCountdownWidget(_getCountdown()),
                ),
              ],
            ),
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Attendees (${_item.count})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${FormatUtils.formatDate(_item.when)}'),
                        const SizedBox(height: 8),
                        Text('Location: ${_item.place} ${_item.mode ? "(Online Link)" : ""}'),
                        const SizedBox(height: 8),
                        Text('Places: ${places.taken} / ${_item.limit} (${places.free} free)'),
                        if (_item.description != null) ...[
                          const SizedBox(height: 16),
                          Text('Description:', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text(_item.description!),
                        ],
                      ],
                    ),
                  ),
                  _item.attendees.isEmpty
                      ? const EmptyStateWidget(
                    icon: Icons.people_outline,
                    message: 'Nobody has registered yet.',
                  )
                      : ListView.builder(
                    itemCount: _item.attendees.length,
                    itemBuilder: (ctx, idx) {
                      final name = _item.attendees[idx];
                      final isYou = name == userName;
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontWeight: isYou ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isYou ? const Chip(label: Text('You')) : null,
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_item.isFull && !isOnList) ? null : _toggleRegistration,
                  child: Text(isOnList ? 'Unregister' : 'Register'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_exception.dart';
import 'new_user_screen.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();

    Widget body;
    if (m.loading && m.items.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = switch (m.error) {
        null => _UserList(items: m.items, onRefresh: m.load),
        NoConnectionException() => _ErrorState(
          icon: Icons.wifi_off,
          message: 'No internet connection. Check your network.',
          onRetry: m.load,
        ),
        NotFoundException() || UnauthorizedException() => _ErrorState(
          icon: Icons.lock_outline,
          message: 'Access denied or resource not found.',
          onRetry: m.load,
        ),
        ServerException(:final status) => _ErrorState(
          icon: Icons.cloud_off,
          message: 'Server error ($status). Please try again later.',
          onRetry: m.load,
        ),
        BadResponseException() => _ErrorState(
          icon: Icons.broken_image_outlined,
          message: 'Unexpected data format from server.',
          onRetry: m.load,
        ),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          unawaited(
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewUserScreen()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({
    required this.items,
    required this.onRefresh,
  });

  final List<User> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = items[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('${user.email} • ${user.address.city}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              unawaited(
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailScreen(user: user),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
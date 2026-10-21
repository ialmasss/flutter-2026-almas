import 'package:flutter/material.dart';
import '../models/user_data.dart';

class SummaryCard extends StatelessWidget {
  final UserData userData;
  final VoidCallback onStartOver;

  const SummaryCard({
    super.key,
    required this.userData,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Name'),
        subtitle: Text(userData.name),
      ),
      ListTile(
        leading: const Icon(Icons.email),
        title: const Text('Email'),
        subtitle: Text(userData.email),
      ),
      ListTile(
        leading: const Icon(Icons.group),
        title: const Text('Group'),
        subtitle: Text(userData.group),
      ),
      ListTile(
        leading: const Icon(Icons.cake),
        title: const Text('Date of Birth'),
        subtitle: Text(userData.birthDate),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 600) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      children: tiles,
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: tiles,
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onStartOver,
            child: const Text('Start over'),
          ),
        ],
      ),
    );
  }
}
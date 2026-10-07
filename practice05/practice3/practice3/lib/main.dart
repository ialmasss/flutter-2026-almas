import 'package:flutter/material.dart';

import 'data.dart';
import 'info_row.dart';
import 'profile_header.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My profile',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('My profile')),
        body: Column(
          children: [
            const ProfileHeader(name: myName, university: myUniversity),
            for (final fact in facts)
              InfoRow(label: fact.label, value: fact.value),
          ],
        ),
      ),
    );
  }
}

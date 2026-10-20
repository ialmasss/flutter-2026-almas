import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileTab extends StatefulWidget {
  final Profile profile;
  final ValueChanged<Profile> onProfileUpdated;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int registeredEventsCount;

  const ProfileTab({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.registeredEventsCount,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _groupController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _groupController = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _nameController.text = widget.profile.name;
      _groupController.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onProfileUpdated(Profile(
        name: _nameController.text.trim(),
        group: _groupController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _groupController,
              decoration: const InputDecoration(
                labelText: 'Group (e.g. CS-201)',
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return null;
                final regExp = RegExp(r'^[A-Z]{2,4}-\d{3}$');
                if (!regExp.hasMatch(val)) {
                  return 'Format must be like CS-201';
                }
                return null;
              },
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 24),
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('System'),
                  selected: widget.currentThemeMode == ThemeMode.system,
                  onSelected: (_) => widget.onThemeModeChanged(ThemeMode.system),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Light'),
                  selected: widget.currentThemeMode == ThemeMode.light,
                  onSelected: (_) => widget.onThemeModeChanged(ThemeMode.light),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Dark'),
                  selected: widget.currentThemeMode == ThemeMode.dark,
                  onSelected: (_) => widget.onThemeModeChanged(ThemeMode.dark),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.event_available, size: 32),
                    const SizedBox(width: 16),
                    Text(
                      'You are on ${widget.registeredEventsCount} lists',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
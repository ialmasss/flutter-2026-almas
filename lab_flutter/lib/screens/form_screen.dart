import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/format.dart';

class FormScreen extends StatefulWidget {
  final Item? initialItem;

  const FormScreen({super.key, this.initialItem});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _placeController;
  late TextEditingController _limitController;
  late TextEditingController _descController;

  late ItemCategory _category;
  late bool _mode;
  late DateTime _when;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem ?? Item.empty();
    _titleController = TextEditingController(text: item.title);
    _placeController = TextEditingController(text: item.place);
    _limitController = TextEditingController(text: item.limit.toString());
    _descController = TextEditingController(text: item.description ?? '');
    _category = item.category;
    _mode = item.mode;
    _when = item.when;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _limitController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final orig = widget.initialItem ?? Item.empty();
    return _titleController.text != orig.title ||
        _placeController.text != orig.place ||
        _limitController.text != orig.limit.toString() ||
        _descController.text != (orig.description ?? '') ||
        _category != orig.category ||
        _mode != orig.mode ||
        _when != orig.when;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (time == null || !mounted) return;

    setState(() {
      _when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() async {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      final newItem = Item(
        id: widget.initialItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _category,
        when: _when,
        limit: int.parse(_limitController.text.trim()),
        attendees: widget.initialItem?.attendees ?? const [],
        mode: _mode,
        place: _placeController.text.trim(),
        description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        favourite: widget.initialItem?.favourite ?? false,
      );

      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if (shouldPop == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.initialItem == null ? 'New Event' : 'Edit Event'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().length < 3) {
                      return 'Title must be 3–60 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ItemCategory>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ItemCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Icon(cat.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(cat.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Online Event'),
                  subtitle: Text(_mode ? 'Location is a web link' : 'Physical location'),
                  value: _mode,
                  onChanged: (val) => setState(() => _mode = val),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _placeController,
                  decoration: InputDecoration(
                    labelText: _mode ? 'Web Link (URL)' : 'Venue Location',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Location is required';
                    if (_mode && !val.contains('://')) {
                      return 'URL must contain ://';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacity Limit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    final n = int.tryParse(val ?? '');
                    if (n == null || n < 1 || n > 500) {
                      return 'Limit must be 1–500';
                    }
                    final currentCount = widget.initialItem?.count ?? 0;
                    if (n < currentCount) {
                      return 'Cannot be less than current attendees ($currentCount)';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDateTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date and Time',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(FormatUtils.formatDate(_when)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
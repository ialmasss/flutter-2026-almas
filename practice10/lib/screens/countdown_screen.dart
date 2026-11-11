import 'dart:async';
import 'package:flutter/material.dart';
import '../api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _selectedSegment = 0;

  // Version A
  late final Stream<int> _stream = countdown(10);

  // Version B
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) {
      setState(() => _left = i);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Version A (StreamBuilder)')),
              ButtonSegment(value: 1, label: Text('Version B (Subscription)')),
            ],
            selected: {_selectedSegment},
            onSelectionChanged: (set) {
              setState(() => _selectedSegment = set.first);
            },
          ),
          Expanded(
            child: Center(
              child: _selectedSegment == 0
                  ? StreamBuilder<int>(
                stream: _stream,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data ?? 10}',
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                },
              )
                  : Text(
                '$_left',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
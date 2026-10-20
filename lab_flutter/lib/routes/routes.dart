import 'package:flutter/material.dart';
import '../models/item.dart';
import '../screens/shell_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/form_screen.dart';

class Routes {
  static const String shell = '/';
  static const String detail = '/detail';
  static const String form = '/form';
}

class DetailArgs {
  final Item item;
  final ValueChanged<Item> onItemUpdated;
  final ValueChanged<String> onItemDeleted;

  DetailArgs({
    required this.item,
    required this.onItemUpdated,
    required this.onItemDeleted,
  });
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.shell:
        return MaterialPageRoute(builder: (_) => const ShellScreen());
      case Routes.detail:
        final args = settings.arguments as DetailArgs;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(
            item: args.item,
            onItemUpdated: args.onItemUpdated,
            onItemDeleted: args.onItemDeleted,
          ),
        );
      case Routes.form:
        final initialItem = settings.arguments as Item?;
        return MaterialPageRoute<Item>(
          builder: (_) => FormScreen(initialItem: initialItem),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Not found')),
          ),
        );
    }
  }
}
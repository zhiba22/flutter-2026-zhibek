import 'package:flutter/material.dart';

import 'models/item.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';

abstract final class Routes {
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';
}

class DetailArgs {
  const DetailArgs({
    required this.item,
    required this.profileName,
    required this.onChanged,
    required this.onDelete,
    required this.onOpenProfile,
  });

  final Item item;
  final String profileName;
  final ValueChanged<Item> onChanged;
  final ValueChanged<Item> onDelete;

  final VoidCallback onOpenProfile;
}

class FormArgs {
  const FormArgs({this.item});
  final Item? item;
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final args = settings.arguments;
  if (settings.name == Routes.detail && args is DetailArgs) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => DetailScreen(args: args),
    );
  }
  if (settings.name == Routes.form && args is FormArgs) {
    return MaterialPageRoute<Item>(
      settings: settings,
      builder: (_) => FormScreen(args: args),
    );
  }
  return null;
}

Route<dynamic> onUnknownRoute(RouteSettings settings) {
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: const Center(child: Text('Not found')),
    ),
  );
}

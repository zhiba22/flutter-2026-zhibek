import 'package:flutter/material.dart';

import '../models/item.dart';
import '../widgets/empty_state.dart';
import '../widgets/items_view.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onToggleFavourite,
    required this.onGoToList,
  });

  final List<Item> items;
  final ValueChanged<Item> onOpen;
  final ValueChanged<Item> onToggleFavourite;
  final VoidCallback onGoToList;

  @override
  Widget build(BuildContext context) {
    final favourites = items.where((i) => i.favourite).toList()
      ..sort((a, b) => a.when.compareTo(b.when)); // sorts the copy only
    if (favourites.isEmpty) {
      return EmptyState(
        icon: Icons.favorite_border,
        message: 'No favourites yet',
        actionLabel: 'Browse meetings',
        onAction: onGoToList,
      );
    }
    return ItemsView(
      items: favourites,
      onOpen: onOpen,
      onToggleFavourite: onToggleFavourite,
    );
  }
}

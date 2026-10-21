import 'package:flutter/material.dart';

import '../models/item.dart';
import 'item_card.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onToggleFavourite,
  });

  final List<Item> items;
  final ValueChanged<Item> onOpen;
  final ValueChanged<Item> onToggleFavourite;

  static const double _wideFrom = 600;
  static const double _maxCellWidth = 360;
  static const double _cellHeight = 140;
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(12, 8, 12, 88);

  Widget _card(Item item) => ItemCard(
    item: item,
    onTap: () => onOpen(item),
    onToggleFavourite: () => onToggleFavourite(item),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _wideFrom) {
          return GridView.builder(
            padding: _padding,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _maxCellWidth,
              mainAxisExtent: _cellHeight,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _card(items[index]),
          );
        }
        return ListView.separated(
          padding: _padding,
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _card(items[index]),
        );
      },
    );
  }
}

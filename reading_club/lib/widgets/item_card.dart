import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleFavourite,
  });

  final Item item;
  final VoidCallback onTap;
  final VoidCallback onToggleFavourite;

  String? get _badge {
    if (item.isFull) return 'FULL';
    if (item.free <= 5) return '${item.free} left';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final badge = _badge;
    final dateText = item.isPast
        ? '${formatDate(item.when)} (past)'
        : formatDate(item.when);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CircleAvatar(
                        backgroundColor: item.genre.color(scheme),
                        foregroundColor: scheme.surface,
                        child: Icon(item.genre.icon),
                      ),
                    ),
                    if (badge != null)
                      Positioned(
                        bottom: -6,
                        left: -4,
                        right: -4,
                        child: Center(
                          child: _Badge(text: badge, full: item.isFull),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(dateText, style: textTheme.bodySmall),
                    Text(
                      item.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                isSelected: item.favourite,
                icon: const Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite, color: scheme.error),
                tooltip: item.favourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                onPressed: onToggleFavourite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.full});

  final String text;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: full ? scheme.error : scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: full ? scheme.onError : scheme.onTertiaryContainer,
        ),
      ),
    );
  }
}

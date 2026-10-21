import 'package:flutter/material.dart';

import '../models/genre.dart';
import '../models/item.dart';
import '../utils/keyboard.dart';
import '../widgets/empty_state.dart';
import '../widgets/items_view.dart';

class ListTab extends StatefulWidget {
  const ListTab({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onToggleFavourite,
    required this.onAdd,
  });

  final List<Item> items;
  final ValueChanged<Item> onOpen;
  final ValueChanged<Item> onToggleFavourite;
  final VoidCallback onAdd;

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  Genre? _genre;
  bool _showPast = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Item> get _visible {
    final q = _query.trim().toLowerCase();
    final matches = widget.items
        .where(
          (i) =>
              (_showPast || !i.isPast) &&
              (_genre == null || i.genre == _genre) &&
              i.title.toLowerCase().contains(q),
        )
        .toList();
    return matches..sort((a, b) => a.when.compareTo(b.when));
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() => _query = '');
  }

  void _clearFilters() {
    _searchCtrl.clear();
    setState(() {
      _query = '';
      _genre = null;
      _showPast = false;
    });
  }

  Widget _content() {
    final visible = _visible;
    if (visible.isNotEmpty) {
      return ItemsView(
        items: visible,
        onOpen: widget.onOpen,
        onToggleFavourite: widget.onToggleFavourite,
      );
    }
    if (widget.items.isEmpty) {
      return EmptyState(
        icon: Icons.menu_book_outlined,
        message: 'No meetings yet',
        actionLabel: 'Add a meeting',
        onAction: widget.onAdd,
      );
    }
    return EmptyState(
      icon: Icons.search_off,
      message: 'No meetings match your search',
      actionLabel: 'Clear filters',
      onAction: _clearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextFormField(
            controller: _searchCtrl,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onTapOutside: dismissKeyboard,
            onChanged: (value) => setState(() => _query = value),
            validator: (value) => null,
            decoration: InputDecoration(
              hintText: 'Search books',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear',
                      onPressed: _clearSearch,
                    ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _genre == null,
                  onSelected: (_) => setState(() => _genre = null),
                ),
              ),
              for (final g in Genre.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(g.icon),
                    label: Text(g.label),
                    selected: _genre == g,
                    onSelected: (_) => setState(() => _genre = g),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              label: const Text('Include past meetings'),
              selected: _showPast,
              onSelected: (value) => setState(() => _showPast = value),
            ),
          ),
        ),
        Expanded(child: _content()),
      ],
    );
  }
}

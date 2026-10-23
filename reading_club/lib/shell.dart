import 'package:flutter/material.dart';

import 'data/seed.dart';
import 'models/item.dart';
import 'models/profile.dart';
import 'routes.dart';
import 'tabs/favourites_tab.dart';
import 'tabs/list_tab.dart';
import 'tabs/profile_tab.dart';

class Shell extends StatefulWidget {
  const Shell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  static const _titles = ['Meetings', 'Favourites', 'Profile'];

  List<Item> _items = seedItems();
  Profile _profile = const Profile.empty();
  int _index = 0;

  void _selectTab(int index) {
    setState(() => _index = index);
  }

  void _replace(Item updated) {
    setState(() {
      _items = [
        for (final i in _items)
          if (i.id == updated.id) updated else i,
      ];
    });
  }

  void _toggleFavourite(Item item) {
    _replace(item.copyWith(favourite: !item.favourite));
  }

  void _delete(Item item) {
    setState(() {
      _items = _items.where((i) => i.id != item.id).toList();
    });
  }

  void _setProfile(Profile profile) {
    setState(() => _profile = profile);
  }

  Future<void> _openNewForm() async {
    final saved = await Navigator.of(context)
        .pushNamed<Item>(Routes.form, arguments: const FormArgs());
    if (saved == null || !mounted) return;
    setState(() => _items = [..._items, saved]);
  }

  void _openDetail(Item item) {
    Navigator.of(context).pushNamed(
      Routes.detail,
      arguments: DetailArgs(
        item: item,
        profileName: _profile.name,
        onChanged: _replace,
        onDelete: _delete,
        onOpenProfile: _showProfileTab,
      ),
    );
  }

  void _showProfileTab() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    _selectTab(2);
  }

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About'),
        content: const Text(
          'Reading Club: books, meeting dates and who borrowed a copy.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text(
          'This restores the existing meetings and clears your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final fresh = seedItems();
    setState(() {
      _items = fresh;
      _profile = const Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Reading Club',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAbout();
              },
            ),
            ListTile(
              title: const Text('Reset data'),
              onTap: () {
                Navigator.pop(context);
                _confirmReset();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          ListTab(
            items: _items,
            onOpen: _openDetail,
            onToggleFavourite: _toggleFavourite,
            onAdd: _openNewForm,
          ),
          FavouritesTab(
            items: _items,
            onOpen: _openDetail,
            onToggleFavourite: _toggleFavourite,
            onGoToList: () => _selectTab(0),
          ),
          ProfileTab(
            profile: _profile,
            items: _items,
            onChanged: _setProfile,
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: _openNewForm,
              tooltip: 'New meeting',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Meetings',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

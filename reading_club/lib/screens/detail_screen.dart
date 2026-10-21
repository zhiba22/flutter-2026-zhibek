import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/item.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

enum _MenuAction { edit, delete }

String _countdownText(Countdown countdown) => switch (countdown) {
  Upcoming(:final timeLeft) => 'Starts in ${formatDuration(timeLeft)}',
  Started(:final elapsed) => 'Started ${formatDuration(elapsed)} ago',
  Ended() => 'Ended',
};

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.args});

  final DetailArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Item _item;
  late DateTime _now;
  late final Timer _timer;

  String get _me => widget.args.profileName.trim();

  bool get _joined => _me.isNotEmpty && _item.contains(_me);

  @override
  void initState() {
    super.initState();
    _item = widget.args.item;
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<bool?> _ask(String title, String body, String yes) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(yes),
          ),
        ],
      ),
    );
  }

  Future<void> _onPrimary() async {
    if (_me.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add your name in the profile first'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: widget.args.onOpenProfile,
          ),
        ),
      );
      return;
    }
    final joined = _joined;
    final ok = await _ask(
      joined ? 'Return this book?' : 'Borrow this book?',
      joined
          ? 'Your copy of "${_item.title}" goes back to the club.'
          : 'You will take a copy of "${_item.title}".',
      joined ? 'Return' : 'Borrow',
    );
    if (ok != true || !mounted) return;
    final updated = joined ? _item.withoutReader(_me) : _item.withReader(_me);
    setState(() => _item = updated);
    widget.args.onChanged(updated);
  }

  Future<void> _edit() async {
    final saved = await Navigator.of(context)
        .pushNamed<Item>(Routes.form, arguments: FormArgs(item: _item));
    if (saved == null || !mounted) return;
    setState(() => _item = saved);
    widget.args.onChanged(saved);
  }

  Future<void> _delete() async {
    final ok = await _ask(
      'Delete meeting?',
      '"${_item.title}" will be removed from the list.',
      'Delete',
    );
    if (ok != true || !mounted) return;
    widget.args.onDelete(_item);
    Navigator.of(context).pop();
  }

  void _onMenu(_MenuAction action) {
    switch (action) {
      case _MenuAction.edit:
        _edit();
      case _MenuAction.delete:
        _delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final canAct = _joined || !item.isFull;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<_MenuAction>(
              onSelected: _onMenu,
              itemBuilder: (context) => const [
                PopupMenuItem(value: _MenuAction.edit, child: Text('Edit')),
                PopupMenuItem(value: _MenuAction.delete, child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            _Header(item: item, countdown: item.countdownAt(_now)),
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Readers (${item.count}/${item.limit})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _AboutTab(item: item),
                  _ReadersTab(item: item, me: _me, onBorrow: _onPrimary),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: canAct ? _onPrimary : null,
                    child: Text(_joined ? 'Return' : 'Borrow'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.item, required this.countdown});

  final Item item;
  final Countdown countdown;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/cover.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                ColoredBox(color: scheme.surfaceContainerHighest),
          ),
          ColoredBox(color: scheme.scrim.withValues(alpha: 0.35)),
          Center(child: Icon(item.genre.icon, size: 72, color: scheme.surface)),
          Positioned(top: 12, left: 12, child: _Tag(text: item.genre.label)),
          Positioned(
            top: 12,
            right: 12,
            child: _Tag(text: _countdownText(countdown)),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: scheme.onSurface),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final (:taken, :free) = item.places;
    final blurb = item.blurb;
    return ListView(
      children: [
        ListTile(
          title: const Text('Date'),
          subtitle: Text(formatDate(item.when)),
        ),
        ListTile(
          title: Text(item.online ? 'Link' : 'Place'),
          subtitle: Text(item.place),
        ),
        ListTile(
          title: const Text('Copies'),
          subtitle: Text('$taken borrowed, $free free of ${item.limit}'),
        ),
        if (blurb != null)
          ListTile(title: const Text('About the book'), subtitle: Text(blurb)),
      ],
    );
  }
}

class _ReadersTab extends StatelessWidget {
  const _ReadersTab({
    required this.item,
    required this.me,
    required this.onBorrow,
  });

  final Item item;
  final String me;
  final VoidCallback onBorrow;

  bool _isYou(String name) =>
      me.isNotEmpty && name.toLowerCase() == me.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final names = item.names;
    if (names.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline,
        message: 'Nobody has borrowed a copy yet',
        actionLabel: 'Borrow',
        onAction: onBorrow,
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) {
        final name = names[index];
        final you = _isYou(name);
        return ListTile(
          tileColor: you ? scheme.primaryContainer : null,
          title: Text(name),
          trailing: you ? const Chip(label: Text('You')) : null,
        );
      },
    );
  }
}

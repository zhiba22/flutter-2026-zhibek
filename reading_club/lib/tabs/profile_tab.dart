import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/profile.dart';
import '../utils/keyboard.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.items,
    required this.onChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final Profile profile;
  final List<Item> items;
  final ValueChanged<Profile> onChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  static final RegExp _groupPattern = RegExp(r'^[A-Za-z]{2,5}-\d{2}$');

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _groupCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _groupFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.profile.name;
    _groupCtrl.text = widget.profile.group;
  }

  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.profile, widget.profile)) return;
    if (_nameCtrl.text.trim() != widget.profile.name) {
      _nameCtrl.text = widget.profile.name;
    }
    if (_groupCtrl.text.trim() != widget.profile.group) {
      _groupCtrl.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _groupCtrl.dispose();
    _nameFocus.dispose();
    _groupFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if ((value ?? '').trim().length < 2) {
      return 'Enter your name (2+ characters)';
    }
    return null;
  }

  String? _validateGroup(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    return _groupPattern.hasMatch(text) ? null : 'Use a format like CS-23';
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    widget.onChanged(
      Profile(name: _nameCtrl.text.trim(), group: _groupCtrl.text.trim()),
    );
  }

  String _label(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profile = widget.profile;
    final lists = profile.isEmpty
        ? 0
        : widget.items.where((i) => i.contains(profile.name)).length;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
                onTapOutside: dismissKeyboard,
                onFieldSubmitted: (_) {
                  _submit();
                  _groupFocus.requestFocus();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _groupCtrl,
                focusNode: _groupFocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  hintText: 'CS-23',
                  border: OutlineInputBorder(),
                ),
                validator: _validateGroup,
                onTapOutside: dismissKeyboard,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          profile.isEmpty
              ? 'Add your name to borrow books.'
              : 'You are on $lists ${lists == 1 ? 'list' : 'lists'}',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        Text('Theme', style: textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final mode in ThemeMode.values)
              ChoiceChip(
                label: Text(_label(mode)),
                selected: widget.themeMode == mode,
                onSelected: (_) => widget.onThemeModeChanged(mode),
              ),
          ],
        ),
      ],
    );
  }
}

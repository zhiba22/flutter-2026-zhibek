import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/genre.dart';
import '../models/item.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../utils/keyboard.dart';

typedef _Snapshot = ({
  String title,
  String place,
  String limit,
  String blurb,
  Genre? genre,
  bool online,
  String date,
  String time,
});

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, required this.args});

  final FormArgs args;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placeKey = GlobalKey<FormFieldState<String>>();
  final _timeKey = GlobalKey<FormFieldState<String>>();

  final _titleCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();
  final _blurbCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _titleFocus = FocusNode();
  final _placeFocus = FocusNode();
  final _limitFocus = FocusNode();
  final _blurbFocus = FocusNode();

  late final Item _base;
  late final _Snapshot _opened;
  late DateTime _date;
  late TimeOfDay _time;
  late bool _online;
  Genre? _genre;

  bool _dirty = false;
  bool _saving = false;

  bool get _isNew => widget.args.item == null;

  @override
  void initState() {
    super.initState();
    final base = widget.args.item ?? Item.empty();
    _base = base;
    _titleCtrl.text = base.title;
    _placeCtrl.text = base.place;
    _limitCtrl.text = base.limit.toString();
    _blurbCtrl.text = base.blurb ?? '';
    _genre = base.genre;
    _online = base.online;
    _date = DateTime(base.when.year, base.when.month, base.when.day);
    _time = TimeOfDay(hour: base.when.hour, minute: base.when.minute);
    _dateCtrl.text = formatDay(_date);
    _timeCtrl.text = formatClock(_time.hour, _time.minute);
    _opened = _snapshot();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _placeCtrl.dispose();
    _limitCtrl.dispose();
    _blurbCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _titleFocus.dispose();
    _placeFocus.dispose();
    _limitFocus.dispose();
    _blurbFocus.dispose();
    super.dispose();
  }

  _Snapshot _snapshot() => (
    title: _titleCtrl.text,
    place: _placeCtrl.text,
    limit: _limitCtrl.text,
    blurb: _blurbCtrl.text,
    genre: _genre,
    online: _online,
    date: _dateCtrl.text,
    time: _timeCtrl.text,
  );

  void _refreshDirty() {
    final dirty = _snapshot() != _opened;
    if (dirty != _dirty) setState(() => _dirty = dirty);
  }

  String? _validateTitle(String? value) {
    final text = (value ?? '').trim();
    if (text.length < 3) return 'At least 3 characters';
    if (text.length > 60) return 'At most 60 characters';
    return null;
  }

  String? _validatePlace(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return _online ? 'Enter a meeting link' : 'Enter a place';
    if (_online && !text.contains('://')) return 'A link must contain ://';
    return null;
  }

  String? _validateLimit(String? value) {
    final n = int.tryParse((value ?? '').trim());
    if (n == null) return 'Enter a number';
    if (n < 1 || n > 500) return 'Between 1 and 500 copies';
    final taken = widget.args.item?.count ?? 0;
    if (n < taken) return 'Not below $taken (already borrowed)';
    return null;
  }

  DateTime get _combined =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Pick a date';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_isNew && _date.isBefore(today)) {
      return 'The date must be in the future';
    }
    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) return 'Pick a time';
    if (_isNew && !_combined.isAfter(DateTime.now())) {
      return 'The meeting must start in the future';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final floor = DateTime(now.year - 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _date.isBefore(floor) ? _date : floor,
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
    _dateCtrl.text = formatDay(picked);
    _timeKey.currentState?.validate();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null || !mounted) return;
    setState(() => _time = picked);
    _timeCtrl.text = formatClock(picked.hour, picked.minute);
  }

  Item _buildItem() {
    final blurb = _blurbCtrl.text.trim();
    return _base.copyWith(
      title: _titleCtrl.text.trim(),
      genre: _genre,
      when: _combined,
      limit: int.tryParse(_limitCtrl.text.trim()) ?? _base.limit,
      place: _placeCtrl.text.trim(),
      online: _online,
      blurb: blurb,
      clearBlurb: blurb.isEmpty,
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context).pop<Item>(_buildItem());
  }

  Future<void> _confirmDiscard(bool didPop) async {
    if (didPop) return;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your edits will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard != true || !mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) => _confirmDiscard(didPop),
      child: Scaffold(
        appBar: AppBar(title: Text(_isNew ? 'New meeting' : 'Edit meeting')),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: _refreshDirty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      focusNode: _titleFocus,
                      maxLength: 60,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Book title',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateTitle,
                      onTapOutside: dismissKeyboard,
                      onFieldSubmitted: (_) => _placeFocus.requestFocus(),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Genre>(
                      initialValue: _genre,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final g in Genre.values)
                          DropdownMenuItem<Genre>(
                            value: g,
                            child: Text(g.label),
                          ),
                      ],
                      validator: (genre) =>
                          genre == null ? 'Choose a category' : null,
                      onChanged: (genre) {
                        setState(() => _genre = genre);
                        _refreshDirty();
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: _validateDate,
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            key: _timeKey,
                            controller: _timeCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.schedule),
                            ),
                            validator: _validateTime,
                            onTap: _pickTime,
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Online meeting'),
                      subtitle: Text(
                        _online ? 'The place is a link' : 'The place is a room',
                      ),
                      value: _online,
                      onChanged: (value) {
                        setState(() => _online = value);
                        if (_placeCtrl.text.isNotEmpty) {
                          _placeKey.currentState?.validate();
                        }
                        _refreshDirty();
                      },
                    ),
                    TextFormField(
                      key: _placeKey,
                      controller: _placeCtrl,
                      focusNode: _placeFocus,
                      keyboardType: _online
                          ? TextInputType.url
                          : TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: _online ? 'Meeting link' : 'Place',
                        hintText: _online
                            ? 'https://meet.example.com/club'
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                      validator: _validatePlace,
                      onTapOutside: dismissKeyboard,
                      onFieldSubmitted: (_) => _limitFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _limitCtrl,
                      focusNode: _limitFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Copies available',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateLimit,
                      onTapOutside: dismissKeyboard,
                      onFieldSubmitted: (_) => _blurbFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _blurbCtrl,
                      focusNode: _blurbFocus,
                      maxLines: 3,
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'About the book (optional)',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => null,
                      onTapOutside: dismissKeyboard,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:collection';

import 'countdown.dart';
import 'genre.dart';

class Item {
  const Item({
    required this.id,
    required this.title,
    required this.genre,
    required this.when,
    required this.limit,
    required this.place,
    this.online = false,
    this.blurb,
    this.favourite = false,
    List<String> names = const [],
  }) : _names = names;

  Item.empty()
    : id = DateTime.now().microsecondsSinceEpoch.toString(),
      title = '',
      genre = Genre.fiction,
      when = _tomorrowEvening(),
      limit = 10,
      place = '',
      online = false,
      blurb = null,
      favourite = false,
      _names = const [];

  final String id;
  final String title;
  final Genre genre;
  final DateTime when;

  final int limit;

  final String place;
  final bool online;

  final String? blurb;
  final bool favourite;

  final List<String> _names;

  List<String> get names => UnmodifiableListView(_names);

  int get count => _names.length;

  int get free => limit > count ? limit - count : 0;

  bool get isFull => count >= limit;

  bool get isPast => when.isBefore(DateTime.now());

  bool contains(String name) {
    final wanted = name.trim().toLowerCase();
    return _names.any((n) => n.toLowerCase() == wanted);
  }

  ({int taken, int free}) get places => (taken: count, free: free);

  Countdown countdownAt(DateTime now) => Countdown.of(when, now);

  Item withReader(String name) => copyWith(names: [..._names, name.trim()]);

  Item withoutReader(String name) {
    final wanted = name.trim().toLowerCase();
    return copyWith(
      names: _names.where((n) => n.toLowerCase() != wanted).toList(),
    );
  }

  Item copyWith({
    String? title,
    Genre? genre,
    DateTime? when,
    int? limit,
    String? place,
    bool? online,
    String? blurb,
    bool clearBlurb = false,
    bool? favourite,
    List<String>? names,
  }) {
    return Item(
      id: id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      place: place ?? this.place,
      online: online ?? this.online,
      blurb: clearBlurb ? null : (blurb ?? this.blurb),
      favourite: favourite ?? this.favourite,
      names: List.unmodifiable(names ?? _names),
    );
  }

  static DateTime _tomorrowEvening() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 18);
  }
}

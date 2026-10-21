import 'package:flutter/material.dart';

enum Genre {
  fiction('Fiction', Icons.auto_stories),
  sciFi('Sci-Fi', Icons.rocket_launch),
  mystery('Mystery', Icons.search),
  history('History', Icons.account_balance),
  nonFiction('Non-fiction', Icons.lightbulb),
  classic('Classic', Icons.menu_book);

  const Genre(this.label, this.icon);

  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) => switch (this) {
    Genre.fiction => scheme.primary,
    Genre.sciFi => scheme.tertiary,
    Genre.mystery => scheme.secondary,
    Genre.history => scheme.error,
    Genre.nonFiction => scheme.onSurfaceVariant,
    Genre.classic => scheme.outline,
  };
}

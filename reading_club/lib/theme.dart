import 'package:flutter/material.dart';

const Color _seed = Color(0xFF3F51B5);

ThemeData buildTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
);

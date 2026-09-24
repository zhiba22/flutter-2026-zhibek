import 'package:flutter/material.dart';

import 'profile_header.dart';
import 'info_row.dart';
import 'data.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My profile')),
        body: Column(
          children: [
            ProfileHeader(name: myName, university: myUniversity),
            for (final fact in facts)
              InfoRow(label: fact.label, value:fact.value),
          ],
        ),
      ),
    ),
  );
}

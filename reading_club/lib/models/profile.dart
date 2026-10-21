class Profile {
  const Profile({required this.name, required this.group});

  const Profile.empty() : name = '', group = '';

  final String name;
  final String group;

  bool get isEmpty => name.trim().isEmpty;

  Profile copyWith({String? name, String? group}) =>
      Profile(name: name ?? this.name, group: group ?? this.group);
}

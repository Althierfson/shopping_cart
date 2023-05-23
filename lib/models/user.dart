class User {
  int? id;
  String? icon;
  String? name;

  User({this.id, this.icon, this.name});

  factory User.fromSQL(Map<String, dynamic> map) {
    return User(id: map['id'], icon: map['icon'], name: map['name']);
  }

  Map<String, dynamic> toSQL() => {'id': id, 'icon': icon, 'name': name};
}

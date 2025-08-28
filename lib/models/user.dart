class User {
  final int? id;
  final String name;
  final String username;
  final String password;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  User copyWith({
    int? id,
    String? name,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }
}

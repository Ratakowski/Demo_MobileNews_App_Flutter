class User {
  final int? id;
  final String username;
  final String password;
  final String? lastLoginLocation;

  User({this.id, required this.username, required this.password, this.lastLoginLocation});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'last_login_location': lastLoginLocation, // Update properti dalam map
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      lastLoginLocation: map['last_login_location'], // Ambil nilai dari map
    );
  }
}



class User {
  const User({
    required this.id,
    this.email,
    this.name,
  });

  final String id;
  final String? email;
  final String? name;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.email == email &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ name.hashCode;
}

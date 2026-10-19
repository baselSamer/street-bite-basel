/// Authenticated user data used by the domain and presentation layers.
///
/// The builder keeps optional profile fields out of constructors at call sites
/// where Firebase only returns a subset of the user's profile.
class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String?,
    photoUrl: json['photoUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
  };
}

/// Builder pattern for creating user entities from Firebase/profile data.
class UserEntityBuilder {
  String? _id;
  String? _email;
  String? _displayName;
  String? _photoUrl;

  UserEntityBuilder id(String value) {
    _id = value;
    return this;
  }

  UserEntityBuilder email(String value) {
    _email = value;
    return this;
  }

  UserEntityBuilder displayName(String? value) {
    _displayName = value;
    return this;
  }

  UserEntityBuilder photoUrl(String? value) {
    _photoUrl = value;
    return this;
  }

  UserEntity build() {
    final id = _id;
    final email = _email;
    if (id == null || email == null) {
      throw StateError('User id and email are required.');
    }
    return UserEntity(
      id: id,
      email: email,
      displayName: _displayName,
      photoUrl: _photoUrl,
    );
  }
}

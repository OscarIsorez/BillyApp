class UserModel {
  String name;
  String email;

  UserModel({
    required this.name,
    required this.email,
  });

  toJson() {
    return {
      'name': name,
      'email': email,
      'theme': 'light',
    };
  }
}

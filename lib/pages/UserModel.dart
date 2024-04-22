class UserModel {
  String name;
  String email;
  String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });

  toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

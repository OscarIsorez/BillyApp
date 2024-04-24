class UserModel {
  String name;
  String email;
  String themeChoosed;
  UserModel({
    required this.name,
    required this.email,
    required this.themeChoosed,
  });

  toJson() {
    return {
      'name': name,
      'email': email,
      'themeChoosed': themeChoosed,
    };
  }
}

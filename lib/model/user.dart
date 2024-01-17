class User {
  String id;
  String fullname;
  String email;
  String setor;
  String? status;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.setor,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        fullname: json['fullname'],
        email: json['email'],
        setor: json['setor']);
  }
}
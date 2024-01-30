class User {
  String id;
  String fullname;
  String email;
  String setor;
  bool? premium;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.setor,
    this.premium,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Extracting the 'setor' as a Map.
    Map<String, dynamic> setor = json['setor'];
    return User(
      id: json['objectId'],
      fullname: json['fullname'],
      email: json['email'],
      setor: setor['name'], // Assign 'name' from 'setor' map to 'setorName'
      premium:
          setor['premium'], // Assign 'premium' from 'setor' map to 'premium'
    );
  }
}

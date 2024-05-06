class User {
  String? id;
  String localId;
  String nome;
  String email;
  String cpfCnpj;
  String dataNascimento;

  User({
    this.id,
    required this.localId,
    required this.nome,
    required this.email,
    required this.cpfCnpj,
    required this.dataNascimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'localId': localId,
      'nome': nome,
      'email': email,
      'cpfCnpj': cpfCnpj,
      'dataNascimento': dataNascimento
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      localId: map['localId'],
      nome: map['nome'],
      email: map['email'],
      cpfCnpj: map['cpfCnpj'],
      dataNascimento: map['dataNascimento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localId': localId,
      'nome': nome,
      'email': email,
      'cpfCnpj': cpfCnpj,
      'dataNascimento': dataNascimento
    };
  }
}

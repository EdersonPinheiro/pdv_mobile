class Group {
  String? id;
  String? localId;
  String name;
  String description;
  String setor;

  Group(
      {this.id,
      this.localId,
      required this.name,
      required this.description,
      this.setor = ''});

  //pega os dados da api e insere nas variaveis da classe
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      localId: json['localId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      setor: json['setor'] ?? ''
    );
  }

  //envia os dados para api
  Map<String, dynamic> toJson() => {
        'id': id,
        'localId': localId,
        'name': name,
        'description': description,
        'setor': setor,
      };
}
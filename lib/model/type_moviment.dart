class TypeMoviment {
  String id;
  String localId;
  String name;
  String? desc;
  String? type;
  String setor;
  String? status;

  TypeMoviment({
    required this.id,
    required this.localId,
    required this.name,
    this.desc,
    this.type,
    required this.setor,
    this.status,
  });

  factory TypeMoviment.fromJson(Map<String, dynamic> json) {
    return TypeMoviment(
      id: json['id'] ?? '',
      localId: json['localId'] ?? '',
      name: json['name'] ?? '',
      desc: json['description'] ?? '',
      type: json['type'] ?? '',
      setor: json['setor'] ?? '',
    );
  }

  //envia os dados para api
  Map<String, dynamic> toJson() => {
        'id': id,
        'localId': localId,
        'name': name,
        'description': desc,
        'type': type,
        'setor': setor
      };
}

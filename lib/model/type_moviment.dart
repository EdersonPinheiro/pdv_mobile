class TypeMoviment {
  String? id;
  String localId;
  String name;
  String? description;
  String? type;
  String? setor;
  String? action;

  TypeMoviment({
    this.id,
    required this.localId,
    required this.name,
    this.description,
    this.type,
    this.setor,
    this.action,
  });

  factory TypeMoviment.fromJson(Map<String, dynamic> json) {
    return TypeMoviment(
      id: json['id'],
      localId: json['localId'] ?? '',
      name: json['name'],
      description: json['description'] ?? '',
      type: json['type'],
      setor: json['setor'],
    );
  }

  //envia os dados para api
  Map<String, dynamic> toJson() => {
        'id': id,
        'localId': localId,
        'name': name,
        'description': description,
        'type': type,
        'setor': setor
      };
}

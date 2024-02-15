class TypeMoviment {
  String? id;
  String localId;
  String name;
  String? type;
  String? setor;
  String? action;

  TypeMoviment({
    this.id,
    required this.localId,
    required this.name,
    this.type,
    this.setor,
    this.action
  });

  factory TypeMoviment.fromJson(Map<String, dynamic> json) {
    return TypeMoviment(
      id: json['id'],
      localId: json['localId'] ?? '',
      name: json['name'],
      type: json['type'],
      setor: json['setor'],
      action: json['action']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'localId': localId,
        'name': name,
        'type': type,
        'setor': setor,
        'action': action
      };
}

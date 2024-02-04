class Product {
  String id;
  String localId;
  String name;
  String description;
  String setor;
  String groups;
  int quantity;
  String? action;
  String? status;

  Product({
    required this.id,
    required this.localId,
    required this.name,
    required this.quantity,
    required this.groups,
    required this.description,
    required this.setor,
    this.action,
    this.status,
  });

  Map<String, dynamic> toJsonDB() {
    return {
      'id': id ?? '',
      'localId': localId,
      'name': name,
      'quantity': quantity,
      'groups': groups,
      'description': description,
      'setor': setor
    };
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'localId': localId,
      'name': name,
      'quantity': quantity,
      'group': groups,
      'description': description,
      'setor': setor,
      'action': action
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        localId: json['localId'],
        name: json['name'],
        quantity: json['quantity'],
        groups: json['group'] ?? '',
        description: json['description'] ?? '',
        setor: json['setor'],
        action: json['action']);
  }
}

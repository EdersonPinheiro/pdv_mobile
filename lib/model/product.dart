class Product {
  String id;
  String? localId;
  String name;
  String description;
  String setor;
  String groups;
  int quantity;
  String? action;

  Product({
    required this.id,
    this.localId,
    required this.name,
    required this.quantity,
    required this.groups,
    required this.description,
    required this.setor,
    this.action,
  });

  Map<String, dynamic> toJsonDB() {
    return {
      'id': id ?? '',
      'localId': localId,
      'name': name,
      'quantity': quantity,
      'groups': groups,
      'description': description,
      'setor': setor,
      'action': action
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
        name: json['name'],
        quantity: json['quantity'],
        groups: json['group'],
        description: json['description'] ?? '',
        setor: json['setor'],
        action: json['action'] ?? '');
  }
}

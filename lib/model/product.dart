class Product {
  String id;
  String localId;
  String name;
  String description;
  String setor;
  String group;
  int quantity;
  String? action;

  Product({
    required this.id,
    required this.localId,
    required this.name,
    required this.quantity,
    required this.group,
    required this.description,
    required this.setor,
    this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'objectId': id,
      'localId': localId,
      'name': name,
      'quantity': quantity,
      'group': group,
      'description': description,
      'setor': setor,
      'action': action
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['objectId'],
      localId: json['localId'],
      name: json['name'],
      quantity: json['quantity'],
      group: json['group'] ?? '',
      description: json['description'],
      setor: json['setor'],
      action: json['action']
    );
  }
}

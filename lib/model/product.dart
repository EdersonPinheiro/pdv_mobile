class Product {
  String id;
  String localId;
  String name;
  String description;
  String setor;
  int quantity;

  Product({
    required this.id,
    required this.localId,
    required this.name,
    required this.description,
    required this.setor,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'objectId': id,
      'localId': localId,
      'name': name,
      'description': description,
      'setor': setor,
      'quantity': quantity,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['objectId'],
      localId: json['localId'],
      name: json['name'],
      description: json['description'],
      setor: json['setor'],
      quantity: json['quantity'],
    );
  }
}

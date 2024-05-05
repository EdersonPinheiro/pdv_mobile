class Product {
  String id;
  String? localId;
  String? codBarras;
  String? image;
  String name;
  String groups;
  int quantity;
  String priceSell;
  String priceBuy;
  String? action;
  int quantitySelected;
  bool isSelected;

  Product(
      {required this.id,
      this.localId,
      this.codBarras,
      this.image,
      required this.name,
      required this.groups,
      required this.quantity,
      required this.priceSell,
      required this.priceBuy,
      this.quantitySelected = 0,
      this.action,
      this.isSelected = false});

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'localId': localId,
      'codBarras': codBarras,
      'image': image,
      'name': name,
      'quantity': quantity,
      'groups': groups,
      'priceSell': priceSell,
      'priceBuy;': priceBuy,
      'action': action,
      'quantitySelected': quantitySelected
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      localId: json['localId'],
      codBarras: json['codBarras'],
      image: json['image'],
      name: json['name'],
      quantity: json['quantity'],
      groups: json['groups'],
      priceSell: json['priceSell'],
      priceBuy: json['priceBuy'] ?? '',
      action: json['action'],
      quantitySelected:
          json['quantitySelected'] ?? 0, // Remove a conversão para int.parse
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, localId: $localId, image: $image, name: $name, quantity: $quantity, groups: $groups, action: $action, priceSell: $priceSell, priceBuy: $priceBuy}';
  }
}

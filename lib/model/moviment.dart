class Moviment {
  String? id;
  String? localId;
  String type;
  String userMov;
  late String dataMov;
  late String hourMov;
  dynamic product;
  dynamic productName;
  dynamic typeMoviment;
  dynamic typeMovimentName;
  int quantityMov;
  String? sync;

  Moviment({
    this.id,
    this.localId,
    required this.type,
    required this.dataMov,
    required this.quantityMov,
    required this.userMov,
    required this.product,
    required this.typeMoviment,
  });

  factory Moviment.fromJson(Map<String, dynamic> json) {
    return Moviment(
        id: json['id'],
        dataMov: json['dataMov'],
        quantityMov: json['quantityMov'] ?? 0,
        type: json['type'].toString(),
        userMov: json['userMov'].toString(),
        product: json['product'],
        typeMoviment: json['typeMoviment'] ?? '',);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'localId': localId,
        'dataMov': dataMov,
        'type': type,
        'userMov': userMov,
        'quantityMov': quantityMov ?? 0,
        'product': product,
        'typeMoviment': typeMoviment,
      };
}
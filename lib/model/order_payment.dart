class OrderPayment {
  final String id;
  final String qrCodeImage;
  final num total;
  final String copiaecola;
  final DateTime? createdAt;
  late final String status;

  OrderPayment(
      {required this.id,
      required this.qrCodeImage,
      required this.total,
      required this.copiaecola,
      this.createdAt, required this.status});

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
        id: json['id'],
        qrCodeImage: json['qrCodeImage'],
        total: json['total'],
        copiaecola: json['copiaecola'],
        createdAt: DateTime.parse(json['createdAt']), status: json['status'] ?? 'pending_payment');
  }

  factory OrderPayment.toJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id'],
      qrCodeImage: json['qrCodeImage'],
      total: json['total'],
      copiaecola: json['copiaecola'],
      status: json['status'],
    );
  }
}
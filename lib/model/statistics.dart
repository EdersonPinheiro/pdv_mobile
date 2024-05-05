class Statistics {
  final String? id;
  final String localId;
  final String totalRevenue;
  final String mostUsedPaymentMethod;
  final String averageTicket;
  final String topSpendingClient;
  final String bestSellingProduct;
  final int date;

  Statistics(
      {
      this.id,
      required this.localId,
      required this.totalRevenue,
      required this.mostUsedPaymentMethod,
      required this.averageTicket,
      required this.topSpendingClient,
      required this.bestSellingProduct,
      required this.date});

  // Método para converter um mapa em um objeto Statistics
  factory Statistics.fromJson(Map<String, dynamic> map) {
    return Statistics(
        localId: map['localId'],
        totalRevenue: map['totalRevenue'],
        mostUsedPaymentMethod: map['mostUsedPaymentMethod'],
        averageTicket: map['averageTicket'],
        topSpendingClient: map['topSpendingClient'],
        bestSellingProduct: map['bestSellingProduct'],
        date: map['date']);
  }

  // Método para converter um objeto Statistics em um mapa
  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'totalRevenue': totalRevenue,
      'mostUsedPaymentMethod': mostUsedPaymentMethod,
      'averageTicket': averageTicket,
      'topSpendingClient': topSpendingClient,
      'bestSellingProduct': bestSellingProduct,
      'date': date
    };
  }
}

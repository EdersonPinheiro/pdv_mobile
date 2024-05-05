
import 'product.dart';

enum TipoDesconto { Percentual, Dinheiro }

class Order {
  final String? id;
  final String localId;
  final String type;
  final int date;
  String? clienteId;
  String? clienteNome;
  final String vendedor;
  final List<Product> product;
  String? valorFrete;
  late String? formaPagamento;
  String total; // Change to String
  String subtotal; // Change to String
  String? desconto; // Change to String
  TipoDesconto? tipoDesconto;

  Order({
    this.id,
    required this.localId,
    required this.type,
    required this.date,
    this.clienteId,
    this.clienteNome,
    required this.vendedor,
    required this.product,
    this.valorFrete,
    this.formaPagamento,
    required this.total,
    required this.subtotal,
    this.desconto,
    this.tipoDesconto,
  });

  String calculateTotal() {
    double calculatedTotal = double.parse(subtotal); // Start with subtotal

    for (var product in product) {
      calculatedTotal +=
          product.quantitySelected * double.parse(product.priceSell);
    }

    if (valorFrete != null) {
      calculatedTotal += double.parse(valorFrete!);
    }

    if (desconto != null) {
      if (tipoDesconto == TipoDesconto.Percentual) {
        calculatedTotal -= calculatedTotal * (double.parse(desconto!) / 100);
      } else {
        calculatedTotal -= double.parse(desconto!);
      }
    }

    total = calculatedTotal.toString();
    return total;
  }
}

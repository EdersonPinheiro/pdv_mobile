import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../controller/product_controller.dart';
import '../../db/db.dart';
import '../../model/order.dart';
import '../../model/product.dart';
import 'confirm_order_page.dart';

class VendasPage extends StatefulWidget {
  @override
  _VendasPageState createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  final ProductController productController = Get.put(ProductController());
  List<Product> cart = [];

  final products = <Product>[].obs;
  final db = DB();
  bool isLoading = false;
  Order? order;

  @override
  void initState() {
    super.initState();
    getProductsDB();
    searchProducts('');
    markProductsSelectedInCart();
  }

  // Verifica se os produtos já estão no carrinho e os marca como selecionados
  void markProductsSelectedInCart() {
    for (Product product in products) {
      final existingIndex = cart.indexWhere((item) => item.id == product.id);
      if (existingIndex != -1) {
        product.isSelected = true;
        product.quantitySelected = cart[existingIndex].quantitySelected;
      } else {
        // Se o produto não estiver no carrinho, desmarque-o e defina a quantidade selecionada como 0
        product.isSelected = false;
      }
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      // Se a consulta estiver vazia, exiba todos os produtos
      products.value = await db.getProductsDB();
    } else {
      // Caso contrário, faça uma consulta no banco de dados com base no texto de pesquisa
      products.value = await db.searchProductsDB(query);
    }
    markProductsSelectedInCart(); // Marca os produtos selecionados baseado no carrinho após a busca
  }

  void addToCart(Product product) {
    setState(() {
      final existingIndex = cart.indexWhere((item) => item.id == product.id);
      if (existingIndex != -1) {
        cart[existingIndex].quantitySelected++;
        //products[products.indexWhere((item) => item.id == product.id)].quantitySelected++;
      } else {
        product.quantitySelected = 1;
        cart.add(product);
      }
      // Marcando o produto como selecionado
      products[products.indexWhere((item) => item.id == product.id)]
          .isSelected = true;
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      final existingIndex = cart.indexWhere((item) => item.id == product.id);
      if (existingIndex != -1) {
        cart[existingIndex]
            .quantitySelected--; // Reduz a quantidade selecionada do produto
        if (cart[existingIndex].quantitySelected == 0) {
          // Se a quantidade selecionada chegar a 0, remova o produto do carrinho
          cart.removeAt(existingIndex);
        }
      }
      // Desmarcando o produto, se não estiver mais no carrinho
      products[products.indexWhere((item) => item.id == product.id)]
          .isSelected = cart.any((item) => item.id == product.id);
    });
  }

  Future<void> getProductsDB() async {
    products.value = await db.getProductsDB();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar por nome ou código',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchProducts(value);
                    });
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        addToCart(product);
                      },
                      child: Card(
                        elevation: 2.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: product.image != null &&
                                            product.image!.isNotEmpty
                                        ? Image.file(File(product.image!))
                                        : Icon(
                                            Icons.image_not_supported_rounded),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'R\$ ${product.priceSell}',
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (product.isSelected)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: Center(
                                    child: Text(
                                      '${product.quantitySelected}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            if (product.isSelected)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.red,
                                  onPressed: () {
                                    removeFromCart(product);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                int millisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
                Order newOrder = Order(
                  id: uuid.v4(),
                  localId: uuid.v4(),
                  type: 'Venda',
                  date: millisSinceEpoch,
                  clienteId: null,
                  clienteNome: null,
                  vendedor: 'Ederson',
                  product: cart,
                  total:
                      calculateTotal().toString(), // Use o total calculado aqui
                  subtotal: calculateTotal()
                      .toString(), // Se necessário, ajuste o subtotal conforme sua lógica
                );
                Get.to(ConfirmOrderPage(order: newOrder));
              },
              child: IgnorePointer(
                ignoring: cart
                    .isEmpty, // Ignora interações se o carrinho estiver vazio
                child: Opacity(
                  opacity: cart.isEmpty
                      ? 0.5
                      : 1.0, // Opacidade reduzida se o carrinho estiver vazio
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('${cart.length}',
                                    style: TextStyle(color: Colors.white)),
                                Text('Itens ',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'R\$ ${calculateTotalPrice()}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotal() {
    double total = 0;
    for (var product in cart) {
      total += double.parse(product.priceSell) * product.quantitySelected;
    }
    return total;
  }

  double calculateTotalPrice() {
    if (cart.isEmpty) return 0;
    return cart
        .map((product) =>
            double.parse(product.priceSell) * product.quantitySelected)
        .reduce((value, element) => value + element);
  }
}

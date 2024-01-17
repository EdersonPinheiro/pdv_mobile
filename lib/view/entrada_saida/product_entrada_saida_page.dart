import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/controllers/type_moviment_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../constants/constants.dart';
import '../../controllers/moviment_controller.dart';
import '../../controllers/product_controller.dart';
import '../../model/moviment.dart';
import '../../model/product.dart';
import '../../model/type_moviment.dart';

class ProductEntradaSaidaPage extends StatefulWidget {
  final Product product;
  final Moviment? moviment;
  final TypeMoviment? typeM;
  //final Function sync;
  final Function reload;
  const ProductEntradaSaidaPage({
    super.key,
    required this.product,
    required this.reload,
    this.moviment,
    this.typeM,
    /*required this.sync*/
  });

  @override
  State<ProductEntradaSaidaPage> createState() =>
      _ProductEntradaSaidaPageState();
}

class _ProductEntradaSaidaPageState extends State<ProductEntradaSaidaPage> {
  ProductController controllerProduct = ProductController();
  MovimentController movimentController = MovimentController();
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
  final ProductController productController = Get.put(ProductController());
  //final SyncController syncController = Get.find();
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  String? _selectedGroup;
  List<TypeMoviment> typeMovimentList = [];
  List typeMoviment = [];
  bool? buttonDisable;
  final uuid = Uuid();
  //BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadBanner();
    getTypeMovimentOff();
  }

  /*void loadBanner() {
    BannerAd(
      adUnitId: AdMobService.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }*/

  Future<void> getTypeMovimentOff() async {
    typeMoviment = await typeMovimentController.getOfflineTypeMoviments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      /*CachedNetworkImage(
                              imageUrl: widget.product.imageUrl,
                              width: 150,
                              height: 80,
                            ),*/
                      Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey,
                      ),
                      TextFormField(
                        controller: controllerProduct.description,
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                      ),
                      TextFormField(
                        controller: controllerProduct.quantity,
                        decoration:
                            const InputDecoration(labelText: 'Quantidade'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Insira a quantidade";
                          } else if (int.tryParse(value) == null) {
                            return "A quantidade deve conter apenas números";
                          } else if (int.parse(value) <= 0) {
                            return "A quantidade deve ser maior que zero";
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                        value: _selectedGroup,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGroup = value;
                            movimentController.typeMovimentController.text =
                                _selectedGroup.toString();
                          });
                        },
                        items: typeMoviment.map((type) {
                          return DropdownMenuItem<String>(
                            onTap: () {
                              if (type.type == "Saída") {
                                setState(() {
                                  buttonDisable = false;
                                });
                              }

                              if (type.type == "Entrada") {
                                setState(() {
                                  buttonDisable = true;
                                });
                              }
                            },
                            value: type.localId,
                            child: Text(type.name),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Tipo de Movimento',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Defina o tipo de movimento';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: buttonDisable == false
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text('Saída'),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await newMoviment("Saida");
                                          widget.reload();
                                          Get.back();
                                        }
                                      })
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey),
                                      child: const Text('Saída'),
                                      onPressed: () async {})),
                          const SizedBox(width: 32),
                          Expanded(
                            child: buttonDisable == true
                                ? ElevatedButton(
                                    child: const Text('Entrada'),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await newMoviment("Entrada");
                                        widget.reload();
                                        Get.back();
                                      }
                                    })
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey),
                                    child: const Text('Entrada'),
                                    onPressed: () async {}),
                          ),
                          /*_bannerAd != null
                              ? Container(child: AdWidget(ad: _bannerAd!))
                              : Container()*/
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> newMoviment(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //fullname = prefs.getString('fullname')!;
    int newQuantity = 0;

    switch (type) {
      case "Entrada":
        setState(() {
          newQuantity = widget.product.quantity +
              int.parse(controllerProduct.quantity.text);
        });
        break;
      case "Saida":
        setState(() {
          newQuantity = widget.product.quantity -
              int.parse(controllerProduct.quantity.text);
        });
        break;
    }

    print("Nova quantidade do produto: ${newQuantity}");

    // Salva a nova quantidade no SharedPreferences
    prefs.setInt('newQuantity', newQuantity);

    final newProduct = Product(
      id: widget.product.id,
      localId: widget.product.localId,
      name: widget.product.name,
      quantity: newQuantity,
      group: widget.product.group,
      description: widget.product.description,
      setor: '',
    );

    final newMoviment = Moviment(
      localId: uuid.v4(),
      product: newProduct.name,
      quantityMov: int.parse(controllerProduct.quantity.text),
      dataMov: dataHoraFormatada(DateTime.now()),
      type: type,
      userMov: fullname,
      typeMoviment: movimentController.typeMovimentController.text,
    );

    movimentController.saveMovimentOffline(newMoviment);
    productController.editProductOffline(newProduct);
  }

  String dataHoraFormatada(DateTime data) {
    return "${data.year.toString().padLeft(4, '0')}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')} "
        "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}:${data.second.toString().padLeft(2, '0')}";
  }
}

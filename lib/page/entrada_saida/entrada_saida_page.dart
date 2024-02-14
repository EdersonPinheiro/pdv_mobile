import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../controllers/product_controller.dart';
import '../../model/product.dart';
import 'product_entrada_saida_page.dart';

class EntradaSaidaPage extends StatefulWidget {
  @override
  _EntradaSaidaPage createState() => _EntradaSaidaPage();
}

class _EntradaSaidaPage extends State<EntradaSaidaPage> {
  final ProductController productController = Get.put(ProductController());
  bool isLoading = true;
  //BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    //syncController.isConn.value == true ? getProductsApi() : getProductsDB();
    //loadBanner();
    getProductsDB();
  }

  /*void loadBanner() {
    BannerAd(
      adUnitId: AdMobService.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.mediumRectangle,
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

  Future<void> getProductsDB() async {
    productController.products.value = await db.getProductsDB();
    for (var element in productController.products) {
      element.name;
    }
    print(productController.products.value);
    print("Buscou os dados do DB");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Entrada/Saída'),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBox) {
            return <Widget>[
              SliverToBoxAdapter(
                child: RefreshIndicator(
                  onRefresh: getProductsDB,
                  key: refreshIndicatorKey,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productController.products.length,
                        itemBuilder: (BuildContext context, int index) {
                          Product product = productController.products[index];
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: Container(
                                        height: 170,
                                        width: 80,
                                        /*child: CachedNetworkImage(
                                imageUrl: product.image.toString(),
                                width: 150,
                                height: 80,
                              ),*/
                                      ),
                                      title: Text(product.name),
                                      subtitle: Text(product.description),
                                      onTap: () async {
                                        Get.to(ProductEntradaSaidaPage(
                                          product: product,
                                          reload: getProductsDB,
                                        ));
                                      },
                                      trailing: Text(
                                          "Qtd. ${product.quantity.toString()}")),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: /*_bannerAd != null ? AdWidget(ad: _bannerAd!) :*/ Container()),
    );
  }
}

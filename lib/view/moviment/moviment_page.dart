import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/moviment_controller.dart';
import '../../model/moviment.dart';

class MovimentacoesPage extends StatefulWidget {
  const MovimentacoesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MovimentacoesPage> createState() => _MovimentacoesPageState();
}

class _MovimentacoesPageState extends State<MovimentacoesPage> {
  final MovimentController movimentController = Get.put(MovimentController());
  String lastData = '';
  bool isLoading = true;
  var currentDate = DateTime.now();
  //BannerAd? _bannerAd;
  String dataFormatada(DateTime data) {
    if (data.year == currentDate.year &&
        data.month == currentDate.month &&
        data.day == currentDate.day) {
      return "Hoje";
    } else {
      return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
    }
  }

  @override
  void initState() {
    super.initState();
    //getMovimentsApi();
    //loadBanner();
    getMovimentsOff();
  }

  Future<void> getMovimentsOff() async {
    movimentController.moviments.value =  await movimentController.getOfflineMoviments();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Movimentações"),
      ),
      body: RefreshIndicator(
        onRefresh: getMovimentsOff,
        key: refreshIndicatorKey,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBox) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: movimentController.moviments.length,
                      itemBuilder: (BuildContext context, int index) {
                        Moviment movimentacao =
                            movimentController.moviments[index];
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
                                  title: Text("${movimentacao.product}"),
                                  subtitle:
                                      Text(movimentacao.quantityMov.toString()),
                                  trailing: movimentacao.type == "Entrada"
                                      ? const Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                        ),
                                  onTap: () {
                                    print(movimentacao.toJson());
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Última movimentação'),
                                          content: Text(
                                            '${movimentacao.product}: ${movimentacao.dataMov}\n'
                                            '${movimentacao.type}\n'
                                            'Usuário: ${movimentacao.userMov}',
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              child: Text('Fechar'),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Container(),
        ),
      ),
    );
  }
}

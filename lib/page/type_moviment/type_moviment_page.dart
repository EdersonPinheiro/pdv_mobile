import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../db/db.dart';
import '../../model/type_moviment.dart';
import 'create_type_moviment_page.dart';
import 'edit_type_moviment_page.dart';

class TypeMovimentPage extends StatefulWidget {
  const TypeMovimentPage({super.key});

  @override
  State<TypeMovimentPage> createState() => _TypeMovimentPageState();
}

class _TypeMovimentPageState extends State<TypeMovimentPage> {
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
  final SyncController syncController = Get.find();
  final typeMoviments = <TypeMoviment>[].obs;
  final db = DB();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getTypeMovimentDB();
    startLiveQuery();
  }

  final LiveQuery liveQueryT = LiveQuery();
  QueryBuilder<ParseObject> queryT =
      QueryBuilder<ParseObject>(ParseObject("TypeMoviment"));

  Future<void> startLiveQuery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final setor = prefs.getString('setor')!;
    Subscription subscription = await liveQueryT.client.subscribe(queryT);

    subscription.on(LiveQueryEvent.create, (value) async {
      if (value['setor'] == setor) {
        await typeMovimentController.handleLiveQueryEventCreate(
            LiveQueryEvent.create, value);
        if (mounted) {
          setState(() {
            getTypeMovimentDB();
          });
        }
      }
    });

    subscription.on(LiveQueryEvent.update, (value) async {
      if (value['setor'] == setor) {
        await typeMovimentController.handleLiveQueryEventUpdate(
            LiveQueryEvent.update, value);
        if (mounted) {
          setState(() {
            getTypeMovimentDB();
          });
        }
      }
    });

    subscription.on(LiveQueryEvent.delete, (value) async {
      if (value['setor'] == setor) {
        await typeMovimentController.handleLiveQueryEventDelete(
            LiveQueryEvent.delete, value);
        if (mounted) {
          setState(() {
            getTypeMovimentDB();
          });
        }
      }
    });
  }

  Future<void> getTypeMovimentDB() async {
    typeMovimentController.typeMoviments.value = await db.getTypeMovimentDB();
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
        title: const Text('Tipos de Movimento'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getTypeMovimentDB,
        child: Obx(() => ListView.builder(
              itemCount: typeMovimentController.typeMoviments.length,
              itemBuilder: (BuildContext context, int index) {
                TypeMoviment typeMoviment =
                    typeMovimentController.typeMoviments[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 218, 211, 211),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text(typeMoviment.name),
                      subtitle: Text(typeMoviment.type.toString()),
                      onTap: () async {
                        print(typeMoviment.toJson());
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          Get.to(EditTypeMovimentPage(
                              typeMoviment: typeMoviment,
                              reload: getTypeMovimentDB));
                        },
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateTypeMovimentPage(
            reload: getTypeMovimentDB,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

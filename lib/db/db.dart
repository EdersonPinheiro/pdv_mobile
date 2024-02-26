import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'package:collection/equality.dart';
import '../constants/constants.dart';
import '../model/group.dart';
import '../model/moviment.dart';
import '../model/product.dart';
import '../model/type_moviment.dart';

class DB {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "nkmnl");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //CRIAÇÃO DE TABELAS
  void _onCreate(Database db, int version) async {
    await createTableProduct(db); // PRODUTOS
    await createTableGroup(db); //GRUPOS
    await createTableMoviment(db); // MOVIMENTAÇÕES
    await createTableTypeMoviment(db); // TIPO DE MOVIMENTO
    await createActionProduct(db); //AÇÕES DO PRODUTO
    await createActionMoviment(db); //AÇÕES DAS MOVIMENTAÇÕES
    await createActionTypeMoviment(db); //AÇÕES DO TIPO DE MOVIMENT NA VENDA
    await createActionGroups(db); // AÇÕES DOS GRUPOS
  }

  Future<void> createTableProduct(Database db) async {
    await db.execute('''
      CREATE TABLE product (
        id TEXT,
        localId TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        quantity INTEGER,
        groups TEXT,
        setor TEXT,
        action TEXT
      )
    ''');
  }

  Future<void> createTableGroup(Database db) async {
    await db.execute('''
      CREATE TABLE groups (
        id TEXT,
        localId TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        setor TEXT,
        action TEXT
      )
''');
  }

  Future<void> createTableMoviment(Database db) async {
    await db.execute('''
      CREATE TABLE moviments (
        id TEXT PRIMARY KEY,
        product TEXT,
        productName TEXT,
        quantityMov INTEGER,
        dataMov TEXT,
        hourMov TEXT,
        status TEXT,
        type TEXT,
        userMov TEXT,
        sync TEXT,
        typeMoviment TEXT
      )
''');
  }

  Future<void> createTableTypeMoviment(Database db) async {
    print("criado o typemoviment");
    await db.execute('''
      CREATE TABLE typemoviment (
        id TEXT,
        localId TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        setor TEXT,
        action TEXT
      )
''');
  }

  Future<void> createActionProduct(Database db) async {
    await db.execute('''
    CREATE TABLE actionproduct (
      id TEXT,
      localId TEXT PRIMARY KEY,
      name TEXT,
      description TEXT,
      quantity INTEGER,
      groups TEXT,
      setor TEXT,
      action TEXT
    )
  ''');
  }

  Future<void> createActionMoviment(Database db) async {
    await db.execute('''
      CREATE TABLE actionmoviment (
        id TEXT,
        localId TEXT,
        product TEXT,
        productName TEXT,
        quantityMov INTEGER,
        dataMov TEXT,
        hourMov TEXT,
        status TEXT,
        type TEXT,
        userMov TEXT,
        sync TEXT,
        typeMoviment TEXT
      )
    ''');
  }

  Future<void> createActionTypeMoviment(Database db) async {
    await db.execute('''
      CREATE TABLE actiontypemoviment (
        id TEXT,
        localId TEXT,
        name TEXT,
        type TEXT,
        action TEXT,
        setor TEXT
      )
    ''');
  }

  Future<void> createActionGroups(Database db) async {
    await db.execute('''
      CREATE TABLE actiongroups (
        id TEXT,
        localId TEXT,
        name TEXT,
        description TEXT,
        setor TEXT,
        action TEXT
      )
    ''');
  }

  //################################################################################################################################################//
  //PRODUCT---------------------------------------------------PRODUCT---------------------------------------------------PRODUCT---------------------//
  //################################################################################################################################################//

  Future<String?> createTypeMoviment(TypeMoviment typeMoviment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken')!;
    final setor = prefs.getString('setor')!;
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/create-type-moviment',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': userToken,
          },
        ),
        data: {
          "localId": typeMoviment.localId,
          "name": typeMoviment.name,
          "type": typeMoviment.type,
          "action": typeMoviment.action,
          "setor": setor,
        },
      );
      String newId = response.data['result'];
      print(newId);

      if (response.statusCode == 200) {
        return newId;
      }

      return "error";
    } catch (e) {
      print(e);
    }
  }

  Future<String?> changeTypeMoviment(TypeMoviment typeMoviment) async {
    try {
      final response = await Dio().post(
          'https://parseapi.back4app.com/parse/functions/edit-type-moviment',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': userToken,
            },
          ),
          data: {
            "id": typeMoviment.id,
            "name": typeMoviment.name,
            "type": typeMoviment.type,
            "status": typeMoviment.action,
          });
      Product.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> deleteTypeMoviment(TypeMoviment typeMoviment) async {
    try {
      final response = await Dio().post(
          'https://parseapi.back4app.com/parse/functions/delete-type-moviment',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': userToken,
            },
          ),
          data: {
            "typeMovimentId": typeMoviment.id,
          });
      Product.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveProducts(List<Product> products) async {
    final dbClient = await db;
    final uuid = Uuid();
    print(products.length);

    // Get the existing product IDs from the database
    final existingProductIds = (await dbClient.query('product'))
        .map((product) => {
              'id': product['id'],
              'name': product['name'],
              'description': product['description'],
              'groups': product['group'],
            })
        .toList();

    // Check if the existing product IDs are the same as the new product IDs
    bool areSame = ListEquality().equals(
        existingProductIds, products.map((product) => product.id).toList());

    if (!areSame) {
      print("Tem produto diferente pra salvar");
      // Clear the existing data in the products table
      await dbClient.delete('product');

      //products = [];

      // Insert the new products into the products table
      for (int i = 0; i < products.length; i++) {
        print(products[i].name);
        await dbClient.insert(
            'product',
            {
              'id': products[i].id,
              'localId': uuid.v4(),
              'name': products[i].name,
              'description': products[i].description,
              'groups': products[i].groups,
              'quantity': products[i].quantity,
              'action': products[i].action,
              'setor': products[i].setor
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    print("Products saved");
  }

  Future<void> addProduct(Product product) async {
    try {
      final dbClient = await db;
      await dbClient.insert('product', {
        'id': product.id,
        'localId': product.localId,
        'name': product.name,
        'description': product.description,
        'quantity': product.quantity,
        'groups': product.groups,
        'setor': product.setor,
        'action': product.action
      });

      print("Produto adicionado");
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future<void> deleteProductLocal() async {
    final dbClient = await db;
    await dbClient.delete('product');
  }

  Future<List<Product>> getProductsDB() async {
    print("DB LOCAL");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('product');
    List<Product> products = [];
    maps.forEach((map) {
      if (map['action'] != "delete") {
        products.add(
          Product(
              id: map['id'],
              localId: map['localId'],
              name: map['name'],
              description: map['description'],
              quantity: map['quantity'],
              groups: map['groups'] ?? '',
              setor: map['setor']),
        );
      }
    });
    print(maps.length);
    return products;
  }

  Future<String> getProductNameId(String objectId) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('product');
    String productName = '';

    maps.forEach((map) {
      if (map['action'] != "delete" && map['id'] == objectId) {
        // Verifique se o valor "status" é diferente de "delete" e se o "id" corresponde ao objectId
        productName = map['name'];
      }
    });

    return productName;
  }

  Future<void> deleteProductDB(Product product) async {
    final dbClient = await db;

    // Atualiza produto na base de dados
    await dbClient.update('product', {"status": "delete"},
        where: 'id = ?' ?? 'localId = ?',
        whereArgs: [product.id ?? product.localId]);
  }

  Future<int> updateProduct(Product product) async {
    final dbClient = await db;
    return await dbClient.update(
      'product',
      product.toJsonDB(),
      where: 'localId = ?',
      whereArgs: [product.localId],
    );
  }

  Future<List<Product>> getProducts() async {
    final dbClient = await db;
    final result = await dbClient.query(
      'product',
      where: 'status IN (?, ?, ?)',
      whereArgs: ['new', 'delete', 'update'],
    );
    return result.map((json) => Product.fromJson(json)).toList();
  }

  //################################################################################################################################################
  //ACTIONPRODUCT---------------------------------------------------ACTIONPRODUCT---------------------------------------------------ACTIONPRODUCT
  //################################################################################################################################################

  Future<void> saveActionProduct(Product product) async {
    final dbClient = await db;

    await dbClient.insert('actionproduct', {
      'id': product.id,
      'localId': product.localId,
      'name': product.name,
      'description': product.description,
      'quantity': product.quantity,
      'groups': product.groups,
      'setor': product.setor,
      'action': product.action,
    });
  }

  Future<List<Product>> getActionProduct() async {
    print("Action Product");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('actionproduct');
    List<Product> products = [];
    maps.forEach((map) {
      products.add(Product(
          id: map['id'],
          localId: map['localId'],
          name: map['name'],
          description: map['description'],
          quantity: map['quantity'],
          groups: map['groups'],
          action: map['action'],
          setor: map['setor']));
    });
    print(maps.length);
    return products;
  }

  Future<void> deleteActionDB(String action) async {
    final dbClient = await db;
    await dbClient.delete(action);
  }

  //################################################################################################################################################
  //ACTIONMOVIMENT---------------------------------------------------ACTIONMOVIMENT---------------------------------------------------ACTIONMOVIMENT
  //################################################################################################################################################

  Future<void> saveActionMoviment(Moviment moviment) async {
    final dbClient = await db;
    await dbClient.insert('actionmoviment', {
      'id': moviment.id,
      'localId': moviment.localId,
      'product': moviment.product,
      'productName': moviment.productName,
      'typeMoviment': moviment.typeMoviment,
      'quantityMov': moviment.quantityMov,
      'dataMov': moviment.dataMov,
      'hourMov': moviment.hourMov,
      'type': moviment.type,
      'userMov': moviment.userMov,
      'sync': moviment.sync
    });
  }

  Future<List<Moviment>> getActionMoviment() async {
    print("Action Moviment");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('actionmoviment');
    List<Moviment> moviments = [];
    maps.forEach((map) {
      moviments.add(Moviment(
          id: map['id'],
          localId: map['localId'],
          product: map['product'],
          quantityMov: map['quantityMov'],
          dataMov: map['dataMov'],
          type: map['type'],
          userMov: map['userMov'],
          typeMoviment: map['typeMoviment']));
    });
    print(maps.length);
    return moviments;
  }

  Future<void> deleteActionMovimentDB() async {
    final dbClient = await db;
    await dbClient.delete('actionmoviment');
  }

  //############################################################################################################################################################################
  //ACTIONTYPEMOVIMENT---------------------------------------------------ACTIONTYPEMOVIMENT---------------------------------------------------ACTIONTYPEMOVIMENT------------------
  //##############################################################################################################################################################################

  Future<void> saveTypeMoviment(List<TypeMoviment> typemoviment) async {
    final dbClient = await db;
    // Clear the existing data in the products table
    final uid = Uuid();
    // Get the existing product IDs from the database
    final existingTypeMovimentIds = (await dbClient.query('typemoviment'))
        .map((typemoviment) => typemoviment['id'])
        .toList();

    // Check if the existing product IDs are the same as the new product IDs
    bool areSame = ListEquality().equals(
        existingTypeMovimentIds, typemoviment.map((type) => type.id).toList());

    if (!areSame) {
      print("Tem typemoviment diferente pra salvar");
      await dbClient.delete('typemoviment');
      // Insert the new products into the products table
      for (int i = 0; i < typemoviment.length; i++) {
        print(typemoviment[i].name);
        await dbClient.insert(
            'typemoviment',
            {
              'id': typemoviment[i].id,
              'localId': uid.v4(),
              'name': typemoviment[i].name,
              'type': typemoviment[i].type,
              'setor': typemoviment[i].setor
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    print("Salvo o typeMoviment");
  }

  Future<void> deleteTypeMovimentDB(TypeMoviment typeMoviment) async {
    final dbClient = await db;

    // Atualiza produto na base de dados
    await dbClient.update('typemoviment', {"status": "delete"},
        where: 'id = ?', whereArgs: [typeMoviment.id]);
  }

  Future<int> updateTypeMovimentDB(TypeMoviment typeMoviment) async {
    final dbClient = await db;
    return await dbClient.update(
      'typemoviment',
      typeMoviment.toJson(),
      where: 'id = ?' ?? 'localId = ?',
      whereArgs: [typeMoviment.id ?? typeMoviment.localId],
    );
  }

  Future<void> saveActionTypeMoviment(TypeMoviment typeMoviment) async {
    final dbClient = await db;
    await dbClient.insert('actiontypemoviment', {
      'id': typeMoviment.id,
      'localId': typeMoviment.localId,
      'name': typeMoviment.name,
      'type': typeMoviment.type,
      'action': typeMoviment.action,
      'setor': typeMoviment.setor
    });
  }

  Future<List<TypeMoviment>> getActionTypeMoviment() async {
    print("Action TypeMoviment");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('actiontypemoviment');
    List<TypeMoviment> typeMoviments = [];
    maps.forEach((map) {
      typeMoviments.add(TypeMoviment(
          id: map['id'],
          localId: map['localId'],
          name: map['name'],
          type: map['type'] ?? '',
          action: map['action'],
          setor: map['setor']));
    });
    print(maps.length);
    return typeMoviments;
  }

  Future<void> deleteActionTypeMoviment() async {
    final dbClient = await db;
    await dbClient.delete('actiontypemoviment');
  }

  //################################################################################################################################################
  //GROUP---------------------------------------------------GROUP---------------------------------------------------GROUP---------------------------
  //################################################################################################################################################

  Future<String?> createGroup(Group groups) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken')!;
    try {
      final response = await Dio()
          .post('https://parseapi.back4app.com/parse/functions/create-group',
              options: Options(
                headers: {
                  'X-Parse-Application-Id': KeyApplicationId,
                  'X-Parse-REST-API-Key': KeyClientKey,
                  'X-Parse-Session-Token': userToken,
                },
              ),
              data: {
            "localId": groups.localId,
            "name": groups.name,
            "description": groups.description,
          });
      Group.fromJson(response.data['result']);
      String newId = response.data['result'];
      print(newId);

      if (response.statusCode == 200) {
        return newId;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> changeGroup(Group groups) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    try {
      final response = await Dio().post(
          'https://parseapi.back4app.com/parse/functions/change-group',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': '${userToken}',
            },
          ),
          data: {
            "id": groups.id,
            "name": groups.name,
            "description": groups.description
          });
      Group.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> deleteGroup(Group groups) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    try {
      final response = await Dio()
          .post('https://parseapi.back4app.com/parse/functions/delete-group',
              options: Options(
                headers: {
                  'X-Parse-Application-Id': KeyApplicationId,
                  'X-Parse-REST-API-Key': KeyClientKey,
                  'X-Parse-Session-Token': '${userToken}',
                },
              ),
              data: {"groupId": groups.id});
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveGroups(List<Group> groups) async {
    final dbClient = await db;
    final uuid = Uuid();
    // Clear the existing data in the products table
    await dbClient.delete('groups');
    // Insert the new groups into the products table
    for (int i = 0; i < groups.length; i++) {
      print(groups[i].name);
      await dbClient.insert(
          'groups',
          {
            'id': groups[i].id,
            'name': groups[i].name,
            'description': groups[i].description,
            'localId': uuid.v4(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    print("Salvo o group");
  }

  Future<void> deleteGroupsDB(Group groups) async {
    final dbClient = await db;

    // Atualiza produto na base de dados
    await dbClient.update('groups', {"status": "delete"},
        where: 'id = ?' ?? 'localId = ?',
        whereArgs: [groups.id ?? groups.localId]);
  }

  Future<int> updateGroups(Group groups) async {
    final dbClient = await db;
    return await dbClient.update(
      'groups',
      groups.toJsonDB(),
      where: 'localId = ?',
      whereArgs: [groups.localId],
    );
  }

  Future<void> addGroup(Group group) async {
    final dbClient = await db;
    await dbClient.insert('groups', {
      'id': group.id,
      'localId': group.localId,
      'name': group.name,
      'description': group.description,
      'action': group.action,
    });
  }

  Future<List<Group>> getGroupDB() async {
    print("DB LOCAL");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('groups');
    List<Group> groups = [];
    for (var map in maps) {
      //if (map['action'] != "delete") {
      groups.add(
        Group(
            id: map['id'],
            localId: map['localId'],
            name: map['name'],
            description: map['description']),
      );
      //}
    }

    print("Tem ${groups.length} groups no banco");
    return groups;
  }

  //############################################################################################################################################################################
  //ACTIONGROUP---------------------------------------------------ACTIONGROUP---------------------------------------------------ACTIONTGROUP-------------------------
  //##############################################################################################################################################################################
  Future<void> saveActionGroup(Group group) async {
    final dbClient = await db;

    await dbClient.insert('actiongroups', {
      'id': group.id,
      'localId': group.localId,
      'name': group.name,
      'description': group.description,
      'setor': group.setor,
      'action': group.action
    });
  }

  Future<List<Group>> getActionGroup() async {
    print("Action Group");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('actiongroups');
    List<Group> groups = [];
    maps.forEach((map) {
      groups.add(Group(
        id: map['id'],
        localId: map['localId'],
        name: map['name'],
        description: map['description'],
        setor: map['setor'],
        action: map['action'],
      ));
    });
    print(maps.length);
    return groups;
  }

  Future<void> deleteActionGroupDB() async {
    final dbClient = await db;
    await dbClient.delete('actiongroups');
  }

  //################################################################################################################################################
  //MOVIMENT---------------------------------------------------MOVIMENT---------------------------------------------------MOVIMENT------------------
  //################################################################################################################################################

  Future<void> saveMoviment(List<Moviment> moviments) async {
    final dbClient = await db;
    // Clear the existing data in the products table
    await dbClient.delete('moviments');
    // Insert the new products into the products table
    for (var mov in moviments) {
      print(mov.product);
      await dbClient.insert(
          'moviments',
          {
            'id': mov.id,
            'product': mov.product, // Change this line
            'productName': mov.productName,
            'quantityMov': mov.quantityMov,
            'dataMov': mov.dataMov,
            'hourMov': mov.hourMov,
            'type': mov.type,
            'userMov': mov.userMov,
            'typeMoviment': mov.typeMoviment
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    print("Salvo o moviment");
  }

  Future<void> addMoviment(Moviment moviment) async {
    final dbClient = await db;
    await dbClient.insert('moviments', {
      'id': moviment.id,
      'product': moviment.product,
      'quantityMov': moviment.quantityMov,
      'dataMov': moviment.dataMov,
      'hourMov': moviment.hourMov,
      'type': moviment.type,
      'userMov': moviment.userMov,
      'sync': moviment.sync,
      'typeMoviment': moviment.typeMoviment
    });
  }

  Future<void> changeMoviment(Moviment moviment) async {
    final dbClient = await db;
    await dbClient.update('moviments', {
      'id': moviment.id,
      'product': moviment.product, // Change this line
      'quantityMov': moviment.quantityMov,
      'dataMov': moviment.dataMov,
      'hourMov': moviment.hourMov,
      'type': moviment.type,
      'userMov': moviment.userMov,
      'typeMoviment': moviment.typeMoviment
    });
  }

  Future<void> deleteMovimentLocal() async {
    final dbClient = await db;
    await dbClient.delete('moviments');
  }

  Future<List<Moviment>> getMovimentDB() async {
    print("DB LOCAL");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('moviments');
    List<Moviment> moviment = [];
    maps.forEach((map) {
      if (map['status'] != "delete") {
        // verifique se o valor "status" é diferente de "delete"
        moviment.add(
          Moviment(
              id: map['id'],
              product: map['product'],
              dataMov: map['dataMov'],
              type: map['type'],
              quantityMov: map['quantityMov'],
              userMov: map['userMov'],
              typeMoviment: map['typeMoviment']),
        );
      }
    });

    print("Tem ${moviment.length} moviments no banco");
    return moviment;
  }

  //################################################################################################################################################
  //TYPEMOVIMENT---------------------------------------------------TYPEMOVIMENT---------------------------------------------------TYPEMOVIMENT------
  //################################################################################################################################################

  Future<void> addTypeMoviment(TypeMoviment typeMoviment) async {
    final dbClient = await db;
    await dbClient.insert('typemoviment', {
      'id': typeMoviment.id,
      'localId': typeMoviment.localId,
      'name': typeMoviment.name,
      'type': typeMoviment.type,
      'action': typeMoviment.action,
      'setor': typeMoviment.setor
    });
  }

  Future<void> changeTypeMovimentDB(TypeMoviment typeMoviment) async {
    final dbClient = await db;
    await dbClient.update('typemoviment', {
      'id': typeMoviment.id,
      'name': typeMoviment.name,
      'type': typeMoviment.type,
      'action': typeMoviment.action
    });
  }

  Future<List<TypeMoviment>> getTypeMovimentDB() async {
    print("DB LOCAL");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('typemoviment');
    List<TypeMoviment> typeMoviment = [];
    for (var map in maps) {
      //if (map['status'] != "delete") {
      typeMoviment.add(TypeMoviment(
          id: map['id'],
          localId: map['localId'],
          name: map['name'],
          type: map['type'],
          action: map['action'],
          setor: map['setor']));
      //}
    }

    print("Tem ${typeMoviment.length} moviments no banco");
    return typeMoviment;
  }
}

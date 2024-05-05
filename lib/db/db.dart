import 'dart:convert';
import 'package:collection/equality.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../model/cliente.dart';
import '../model/order.dart';
import '../model/product.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import '../model/statistics.dart';

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
    String path = join(databasesPath, "ikgod");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await createTableProducts(db); // PRODUTOS
    await createTableCliente(db);
    await createTableOrder(db);
    await createTableStatistics(db);
  }

  Future<List<Statistics>> getStaticsByDate(String dateType) async {
    final dbClient = await db;
    List<Statistics> statistics = [];

    DateTime startDate;
    DateTime endDate = DateTime.now();

    switch (dateType) {
      case 'Hoje':
        startDate = DateTime(endDate.year, endDate.month, endDate.day);
        break;
      case 'Ontem':
        endDate =
            DateTime(endDate.year, endDate.month, endDate.day - 1, 23, 59, 59);
        startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
        break;
      case 'Ultimos 6 dias':
        startDate = endDate.subtract(const Duration(days: 6));
        break;
      case 'Últimos 30 dias':
        startDate = endDate.subtract(const Duration(days: 29));
        break;
      case 'Ultimos 3 meses':
        startDate = endDate.subtract(const Duration(days: 90));
        break;
      case 'Ultimos 6 meses':
        startDate = endDate.subtract(const Duration(days: 180));
        break;
      default:
        throw ArgumentError('Tipo de data inválido: $dateType');
    }

    final int startDateMilliseconds = startDate.millisecondsSinceEpoch;
    final int endDateMilliseconds = endDate.millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM `statistics` WHERE date BETWEEN $startDateMilliseconds AND $endDateMilliseconds");

    maps.forEach((map) {
      statistics.add(Statistics(
        localId: map['localId'],
        totalRevenue: map['totalRevenue'],
        mostUsedPaymentMethod: map['mostUsedPaymentMethod'],
        averageTicket: map['averageTicket'],
        topSpendingClient: map['topSpendingClient'],
        bestSellingProduct: map['bestSellingProduct'],
        date: map['date'],
      ));
    });

    return statistics;
  }

  Future<void> addStatistics(Statistics statistics) async {
    final dbClient = await db;
    await dbClient.insert('statistics', {
      'localId': statistics.localId,
      'totalRevenue': statistics.totalRevenue,
      'mostUsedPaymentMethod': statistics.mostUsedPaymentMethod,
      'averageTicket': statistics.averageTicket,
      'topSpendingClient': statistics.topSpendingClient,
      'bestSellingProduct': statistics.bestSellingProduct,
      'date': statistics.date
    });
  }

  Future<List<Statistics>> getStatistics() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('statistics');
    List<Statistics> statisticsList = [];
    for (var map in maps) {
      Statistics statistics = Statistics(
        localId: map['localId'],
        totalRevenue: map['totalRevenue'],
        mostUsedPaymentMethod: map['mostUsedPaymentMethod'],
        averageTicket: map['averageTicket'],
        topSpendingClient: map['topSpendingClient'],
        bestSellingProduct: map['bestSellingProduct'],
        date: map['date'],
      );
      statisticsList.add(statistics);
    }
    return statisticsList;
  }

  Future<void> createTableStatistics(Database db) async {
    await db.execute('''
    CREATE TABLE statistics (
      id TEXT,
      localId TEXT PRIMARY KEY,
      totalRevenue TEXT,
      mostUsedPaymentMethod TEXT,
      averageTicket TEXT,
      topSpendingClient TEXT,
      bestSellingProduct TEXT,
      date INTEGER
    )
  ''');
  }

  Future<List<Product>> searchProductsDB(String query) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM product WHERE name LIKE '%$query%' OR codBarras LIKE '%$query%'");
    List<Product> products = [];
    maps.forEach((map) {
      if (map['action'] != "delete") {
        products.add(Product(
            id: map['id'],
            localId: map['localId'],
            codBarras: map['codBarras'],
            image: map['image'],
            name: map['name'],
            groups: map['groups'],
            quantity: map['quantity'],
            priceSell: map['priceSell'],
            priceBuy: map['priceBuy'],
            action: map['action']));
      }
    });
    return products;
  }

  Future<List<Order>> getOrdersByDate(String dateType) async {
    final dbClient = await db;
    List<Order> orders = [];

    DateTime startDate;
    DateTime endDate = DateTime.now();

    switch (dateType) {
      case 'Hoje':
        startDate = DateTime(endDate.year, endDate.month, endDate.day);
        break;
      case 'Ontem':
        endDate =
            DateTime(endDate.year, endDate.month, endDate.day - 1, 23, 59, 59);
        startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
        break;
      case 'Últimos 7 dias':
        startDate = endDate.subtract(const Duration(days: 6));
        break;
      case 'Últimos 30 dias':
        startDate = endDate.subtract(const Duration(days: 29));
        break;
      case 'Últimos 3 meses':
        startDate = endDate.subtract(const Duration(days: 90));
        break;
      case 'Últimos 6 meses':
        startDate = endDate.subtract(const Duration(days: 180));
        break;
      default:
        throw ArgumentError('Tipo de data inválido: $dateType');
    }

    final int startDateMilliseconds = startDate.millisecondsSinceEpoch;
    final int endDateMilliseconds = endDate.millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM `order` WHERE date BETWEEN $startDateMilliseconds AND $endDateMilliseconds");

    maps.forEach((map) {
      List<dynamic> productsJson = jsonDecode(map['products']);
      List<Product> products =
          productsJson.map((p) => Product.fromJson(p)).toList();

      orders.add(Order(
        id: map['id'],
        localId: map['localId'],
        type: map['type'],
        date: map['date'],
        clienteId: map['clienteId'],
        clienteNome: map['clienteNome'],
        vendedor: map['vendedor'],
        product: products,
        valorFrete: map['valorFrete'],
        formaPagamento: map['formaPagamento'],
        total: map['total'],
        subtotal: map['subtotal'],
        desconto: map['desconto'],
        tipoDesconto: map['tipoDesconto'],
      ));
    });

    return orders;
  }

  Future<void> createTableOrder(Database db) async {
    await db.execute('''
    CREATE TABLE `order` (
      id TEXT,
      localId TEXT PRIMARY KEY,
      type TEXT,
      date INTEGER,
      clienteId TEXT,
      clienteNome TEXT,
      vendedor TEXT,
      products TEXT,
      valorFrete TEXT,
      formaPagamento TEXT,
      total TEXT,
      subtotal TEXT,
      desconto TEXT,
      tipoDesconto TEXT
    )
  ''');
  }

  Future<void> addOrder(Order order) async {
    final dbClient = await db;
    await dbClient.insert('order', {
      'id': order.id,
      'localId': order.localId,
      'type': order.type,
      'date': order.date,
      'clienteId': order.clienteId,
      'clienteNome': order.clienteNome,
      'vendedor': order.vendedor,
      'products': jsonEncode(order.product.map((p) => p.toJson()).toList()),
      'valorFrete': order.valorFrete,
      'formaPagamento': order.formaPagamento,
      'total': order.total,
      'subtotal': order.subtotal,
      'desconto': order.desconto,
      'tipoDesconto': order.tipoDesconto?.toString(),
    });
  }

  Future<List<Order>> getOrderDB() async {
    print("Fetching Orders from DB");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('order');
    List<Order> orders = [];
    maps.forEach((map) {
      List<dynamic> productsJson =
          jsonDecode(map['products']); // Deserialize products from JSON
      List<Product> products =
          productsJson.map((p) => Product.fromJson(p)).toList();

      orders.add(Order(
        id: map['id'],
        localId: map['localId'],
        type: map['type'],
        date: map['date'],
        clienteId: map['clienteId'],
        clienteNome: map['clienteNome'],
        vendedor: map['vendedor'],
        product: products,
        valorFrete: map['valorFrete'],
        formaPagamento: map['formaPagamento'],
        total: map['total'],
        subtotal: map['subtotal'],
        desconto: map['desconto'],
        tipoDesconto: map['tipoDesconto'],
      ));
    });
    print("Fetched ${maps.length} orders");
    return orders;
  }

  Future<void> createTableCliente(Database db) async {
    await db.execute('''
    CREATE TABLE cliente (
      id TEXT,
      localId TEXT PRIMARY KEY,
      nome TEXT,
      email TEXT,
      telefone TEXT,
      cpfCnpj TEXT,
      observacao TEXT,
      endereco TEXT
    )
  ''');
  }

  Future<void> addCliente(Cliente cliente) async {
    final dbClient = await db;
    await dbClient.insert('cliente', {
      'id': cliente.id,
      'localId': cliente.localId,
      'nome': cliente.nome,
      'email': cliente.email,
      'telefone': cliente.telefone,
      'cpfCnpj': cliente.cpfCnpj,
      'observacao': cliente.observacao,
      'endereco': cliente.endereco,
    });
  }

  Future<List<Cliente>> getClientesDB() async {
    print("DB LOCAL");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('cliente');
    List<Cliente> clientes = [];
    maps.forEach((map) {
      if (map['action'] != "delete") {
        clientes.add(Cliente(
          id: map['id'],
          localId: map['localId'],
          nome: map['nome'],
          email: map['email'],
          telefone: map['telefone'],
          cpfCnpj: map['cpfCnpj'],
          observacao: map['observacao'],
        ));
      }
    });
    print(maps.length);
    return clientes;
  }

  Future<void> updateCliente(Cliente cliente) async {
    final dbClient = await db;
    await dbClient.update(
      'cliente',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<void> deleteCliente(int id) async {
    final dbClient = await db;
    await dbClient.delete(
      'cliente',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> createTableProducts(Database db) async {
    await db.execute('''
      CREATE TABLE product (
        id TEXT,
        localId TEXT PRIMARY KEY,
        codBarras TEXT,
        image TEXT,
        name TEXT,
        groups TEXT,
        quantity INTEGER,
        priceSell TEXT,
        priceBuy TEXT,
        action TEXT
      )
    ''');
  }

  Future<void> addProduct(Product product) async {
    final dbClient = await db;
    await dbClient.insert('product', {
      'id': product.id,
      'localId': product.localId,
      'codBarras': product.codBarras,
      'image': product.image,
      'name': product.name,
      'groups': product.groups,
      'quantity': product.quantity,
      'priceSell': product.priceSell,
      'priceBuy': product.priceBuy,
      'action': product.action
    });
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
        products.add(Product(
            id: map['id'],
            localId: map['localId'],
            codBarras: map['codBarras'],
            image: map['image'],
            name: map['name'],
            groups: map['groups'],
            quantity: map['quantity'],
            priceSell: map['priceSell'],
            priceBuy: map['priceBuy'],
            action: map['action']));
      }
    });
    print(maps.length);
    return products;
  }

  Future<void> deleteProductDB(Product product) async {
    final dbClient = await db;

    // Atualiza produto na base de dados
    await dbClient.update('product', {"action": "delete"},
        where: 'localId = ?', whereArgs: [product.localId]);
  }

  Future<int> updateProduct(Product product) async {
    final dbClient = await db;
    return await dbClient.update(
      'product',
      product.toJson(),
      where: 'localId = ?',
      whereArgs: [product.localId],
    );
  }
}

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/product.dart';

class ProductController extends GetxController {
  final dio = new Dio();
  List actioProducts = <Product>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final id = TextEditingController();
  final localId = TextEditingController();
  final name = TextEditingController();
  final quantity = TextEditingController();
  final group = TextEditingController();
  final description = TextEditingController();
  final setor = TextEditingController();
}
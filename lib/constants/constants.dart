import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../db/db.dart';

final formKey = GlobalKey<FormState>();
String userToken = '';
late String fullname;
late String setor;
late String email;
const b4a = 'https://parseapi.back4app.com/parse/functions';
const KeyApplicationId = 'lBYPRb4VMe0YtUkaqBfNwUnqijT8QIE8MIxLNb3x';
const KeyClientKey = 'D8lXCcjSpU6lsyprvoKg2PnYoFbp229gFskyaxY5';
const KeyParseServerUrl = 'https://parseapi.back4app.com';
final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();
const uuid = Uuid();
DB db = DB();

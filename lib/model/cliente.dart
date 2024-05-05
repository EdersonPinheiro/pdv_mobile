import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Cliente {
  String? id;
  String localId;
  String nome;
  String? telefone;
  String? email;
  String? cpfCnpj;
  String? observacao;
  String? endereco;
  String? action;

  Cliente({
    this.id,
    required this.localId,
    required this.nome,
    this.email,
    this.telefone,
    this.cpfCnpj,
    this.observacao,
    this.endereco,
    this.action
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'localId': localId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpfCnpj': cpfCnpj,
      'observacao': observacao,
      'endereco': endereco,
      'action': action
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      localId: map['localId'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      cpfCnpj: map['cpfCnpj'],
      observacao: map['observacao'],
      endereco: map['endereco'],
      action: map['action']
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Groups {
  final String? id;
  final String localId;
  final String name;
  final String? description;

  Groups(
      {this.id, required this.localId, required this.name, this.description});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'localId': localId,
      'name': name,
      'description': description,
    };
  }

  factory Groups.fromMap(Map<String, dynamic> map) {
    return Groups(
        id: map['id'],
        localId: map['localId'],
        name: map['name'],
        description: map['description']);
  }

  String toJson() => json.encode(toMap());

  factory Groups.fromJson(String source) =>
      Groups.fromMap(json.decode(source) as Map<String, dynamic>);
}

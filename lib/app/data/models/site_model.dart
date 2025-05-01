// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../core/utils/storage_box.dart' show StorageBox;

List<SiteModel> listSiteModel(List str) {
  return str.map((el) => SiteModel.fromMap(el)).toList();
}

class SiteModel {
  String? id;
  String name;
  SiteModel({this.id, required this.name});

  SiteModel copyWith({String? id, String? name, String? token}) {
    return SiteModel(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(id: map['id'], name: map['name'] as String);
  }
  void saveToBox() {
    StorageBox.id.val = id ?? '';
    StorageBox.name.val = name;
  }

  String toJson() => json.encode(toMap());

  factory SiteModel.fromJson(String source) =>
      SiteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SiteModel(id: $id, id: $id, name: $name)';
  }

  @override
  bool operator ==(covariant SiteModel other) {
    if (identical(this, other)) return true;

    return other.name == name ||
        (other.id == id && other.id == id && other.name == name);
  }

  @override
  int get hashCode {
    return id.hashCode ^ id.hashCode ^ name.hashCode;
  }
}

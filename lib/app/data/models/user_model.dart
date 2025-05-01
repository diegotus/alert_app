// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../core/utils/storage_box.dart' show StorageBox;

class UserModel {
  String? id;
  String name;
  String phone;
  String site;
  String token;
  UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.site,
    required this.token,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? site,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      site: site ?? this.site,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'site': site,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] as String,
      phone: map['phone'] as String,
      site: map['site'] as String,
      token: map['token'] as String,
    );
  }
  void saveToBox() {
    StorageBox.id.val = id ?? '';
    StorageBox.name.val = name;
    StorageBox.phone.val = phone;
    StorageBox.site.val = site;
    StorageBox.fmcToken.val = token;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, id: $id, name: $name, phone: $phone, site: $site, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.site == site &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        site.hashCode ^
        token.hashCode;
  }
}

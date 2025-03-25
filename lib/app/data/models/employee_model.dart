import 'dart:convert';

class EmployeeModel {
  final String? id;
  final String? name;
  final String? img;
  final String? email;
  final String? phone;
  final bool? active;
  final bool? admin;
  final bool? superAdmin;
  EmployeeModel({
    this.id,
    this.name,
    this.img,
    this.email,
    this.phone,
    this.active,
    this.admin,
    this.superAdmin,
  });

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? img,
    String? email,
    String? phone,
    bool? active,
    bool? admin,
    bool? superAdmin,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      img: img ?? this.img,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      admin: admin ?? this.admin,
      superAdmin: superAdmin ?? this.superAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (img != null) {
      result.addAll({'img': img});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (active != null) {
      result.addAll({'active': active});
    }
    if (admin != null) {
      result.addAll({'admin': admin});
    }
    if (superAdmin != null) {
      result.addAll({'superAdmin': superAdmin});
    }

    return result;
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'],
      img: map['img'],
      email: map['email'],
      phone: map['phone'],
      active: map['active'],
      admin: map['admin'],
      superAdmin: map['superAdmin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EmployeeModel(id: $id, name: $name, img: $img, email: $email, phone: $phone, active: $active, admin: $admin, superAdmin: $superAdmin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmployeeModel &&
        other.id == id &&
        other.name == name &&
        other.img == img &&
        other.email == email &&
        other.phone == phone &&
        other.active == active &&
        other.admin == admin &&
        other.superAdmin == superAdmin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        img.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        active.hashCode ^
        admin.hashCode ^
        superAdmin.hashCode;
  }
}

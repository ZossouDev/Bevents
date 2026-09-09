// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Administrateur {
     int? idAdmin;
     String? nomAdmin;
     String? prenomAdmin;
     String? emailAdmin;
     String? passwordAdmin;
     String? telephoneAdmin;
     String? adresseAdmin;
     String? imageAdmin;
     String? role;
  Administrateur({
    this.idAdmin,
    this.nomAdmin,
    this.prenomAdmin,
    this.emailAdmin,
    this.passwordAdmin,
    this.telephoneAdmin,
    this.adresseAdmin,
    this.imageAdmin,
    this.role,
  });

  Administrateur copyWith({
    int? idAdmin,
    String? nomAdmin,
    String? prenomAdmin,
    String? emailAdmin,
    String? passwordAdmin,
    String? telephoneAdmin,
    String? adresseAdmin,
    String? imageAdmin,
    String? role,
  }) {
    return Administrateur(
      idAdmin: idAdmin ?? this.idAdmin,
      nomAdmin: nomAdmin ?? this.nomAdmin,
      prenomAdmin: prenomAdmin ?? this.prenomAdmin,
      emailAdmin: emailAdmin ?? this.emailAdmin,
      passwordAdmin: passwordAdmin ?? this.passwordAdmin,
      telephoneAdmin: telephoneAdmin ?? this.telephoneAdmin,
      adresseAdmin: adresseAdmin ?? this.adresseAdmin,
      imageAdmin: imageAdmin ?? this.imageAdmin,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idAdmin': idAdmin,
      'nomAdmin': nomAdmin,
      'prenomAdmin': prenomAdmin,
      'emailAdmin': emailAdmin,
      'passwordAdmin': passwordAdmin,
      'telephoneAdmin': telephoneAdmin,
      'adresseAdmin': adresseAdmin,
      'imageAdmin': imageAdmin,
      'role': role,
    };
  }

  factory Administrateur.fromMap(Map<String, dynamic> map) {
    return Administrateur(
      idAdmin: map['idAdmin'] != null ? map['idAdmin'] as int : null,
      nomAdmin: map['nomAdmin'] != null ? map['nomAdmin'] as String : null,
      prenomAdmin: map['prenomAdmin'] != null ? map['prenomAdmin'] as String : null,
      emailAdmin: map['emailAdmin'] != null ? map['emailAdmin'] as String : null,
      passwordAdmin: map['passwordAdmin'] != null ? map['passwordAdmin'] as String : null,
      telephoneAdmin: map['telephoneAdmin'] != null ? map['telephoneAdmin'] as String : null,
      adresseAdmin: map['adresseAdmin'] != null ? map['adresseAdmin'] as String : null,
      imageAdmin: map['imageAdmin'] != null ? map['imageAdmin'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Administrateur.fromJson(String source) => Administrateur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Administrateur(idAdmin: $idAdmin, nomAdmin: $nomAdmin, prenomAdmin: $prenomAdmin, emailAdmin: $emailAdmin, telephoneAdmin: $telephoneAdmin, adresseAdmin: $adresseAdmin, imageAdmin: $imageAdmin, role: $role)';
  }

  @override
  bool operator ==(covariant Administrateur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idAdmin == idAdmin &&
      other.nomAdmin == nomAdmin &&
      other.prenomAdmin == prenomAdmin &&
      other.emailAdmin == emailAdmin &&
      other.passwordAdmin == passwordAdmin &&
      other.telephoneAdmin == telephoneAdmin &&
      other.adresseAdmin == adresseAdmin &&
      other.imageAdmin == imageAdmin &&
      other.role == role;
  }

  @override
  int get hashCode {
    return idAdmin.hashCode ^
      nomAdmin.hashCode ^
      prenomAdmin.hashCode ^
      emailAdmin.hashCode ^
      passwordAdmin.hashCode ^
      telephoneAdmin.hashCode ^
      adresseAdmin.hashCode ^
      imageAdmin.hashCode ^
      role.hashCode;
  }
}

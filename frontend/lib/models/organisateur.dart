// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Organisateur {
  int? idOrga;
  String? nomOrga;
  String? prenomOrga;
  String? emailOrga;
  String? passwordOrga;
  int? telephoneOrga;
  String? adresseOrga;
  String? imageOrga;
  Organisateur({
    this.idOrga,
    this.nomOrga,
    this.prenomOrga,
    this.emailOrga,
    this.passwordOrga,
    this.telephoneOrga,
    this.adresseOrga,
    this.imageOrga,
  });

  Organisateur copyWith({
    int? idOrga,
    String? nomOrga,
    String? prenomOrga,
    String? emailOrga,
    String? passwordOrga,
    int? telephoneOrga,
    String? adresseOrga,
    String? imageOrga,
  }) {
    return Organisateur(
      idOrga: idOrga ?? this.idOrga,
      nomOrga: nomOrga ?? this.nomOrga,
      prenomOrga: prenomOrga ?? this.prenomOrga,
      emailOrga: emailOrga ?? this.emailOrga,
      passwordOrga: passwordOrga ?? this.passwordOrga,
      telephoneOrga: telephoneOrga ?? this.telephoneOrga,
      adresseOrga: adresseOrga ?? this.adresseOrga,
      imageOrga: imageOrga ?? this.imageOrga,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idOrga': idOrga,
      'nomOrga': nomOrga,
      'prenomOrga': prenomOrga,
      'emailOrga': emailOrga,
      'passwordOrga': passwordOrga,
      'telephoneOrga': telephoneOrga,
      'adresseOrga': adresseOrga,
      'imageOrga': imageOrga,
    };
  }

  factory Organisateur.fromMap(Map<String, dynamic> map) {
    return Organisateur(
      idOrga: map['idOrga'] != null ? map['idOrga'] as int : null,
      nomOrga: map['nomOrga'] != null ? map['nomOrga'] as String : null,
      prenomOrga: map['prenomOrga'] != null ? map['prenomOrga'] as String : null,
      emailOrga: map['emailOrga'] != null ? map['emailOrga'] as String : null,
      passwordOrga: map['passwordOrga'] != null ? map['passwordOrga'] as String : null,
      telephoneOrga: map['telephoneOrga'] != null ? map['telephoneOrga'] as int : null,
      adresseOrga: map['adresseOrga'] != null ? map['adresseOrga'] as String : null,
      imageOrga: map['imageOrga'] != null ? map['imageOrga'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Organisateur.fromJson(String source) => Organisateur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Organisateur(idOrga: $idOrga, nomOrga: $nomOrga, prenomOrga: $prenomOrga, emailOrga: $emailOrga, telephoneOrga: $telephoneOrga, adresseOrga: $adresseOrga, imageOrga: $imageOrga)';
  }

  @override
  bool operator ==(covariant Organisateur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idOrga == idOrga &&
      other.nomOrga == nomOrga &&
      other.prenomOrga == prenomOrga &&
      other.emailOrga == emailOrga &&
      other.passwordOrga == passwordOrga &&
      other.telephoneOrga == telephoneOrga &&
      other.adresseOrga == adresseOrga &&
      other.imageOrga == imageOrga;
  }

  @override
  int get hashCode {
    return idOrga.hashCode ^
      nomOrga.hashCode ^
      prenomOrga.hashCode ^
      emailOrga.hashCode ^
      passwordOrga.hashCode ^
      telephoneOrga.hashCode ^
      adresseOrga.hashCode ^
      imageOrga.hashCode;
  }
}

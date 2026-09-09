// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Visiteur {
  int? idVisiteur;  
  String? nomVisiteur;
  String? prenomVisiteur;
  String? emailVisiteur;
  String? passwordVisiteur;
  int? telephoneVisiteur;
  String? adresseVisiteur;
  Visiteur({
    this.idVisiteur,
    this.nomVisiteur,
    this.prenomVisiteur,
    this.emailVisiteur,
    this.passwordVisiteur,
    this.telephoneVisiteur,
    this.adresseVisiteur,
  });

  Visiteur copyWith({
    int? idVisiteur,
    String? nomVisiteur,
    String? prenomVisiteur,
    String? emailVisiteur,
    String? passwordVisiteur,
    int? telephoneVisiteur,
    String? adresseVisiteur,
  }) {
    return Visiteur(
      idVisiteur: idVisiteur ?? this.idVisiteur,
      nomVisiteur: nomVisiteur ?? this.nomVisiteur,
      prenomVisiteur: prenomVisiteur ?? this.prenomVisiteur,
      emailVisiteur: emailVisiteur ?? this.emailVisiteur,
      passwordVisiteur: passwordVisiteur ?? this.passwordVisiteur,
      telephoneVisiteur: telephoneVisiteur ?? this.telephoneVisiteur,
      adresseVisiteur: adresseVisiteur ?? this.adresseVisiteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idVisiteur': idVisiteur,
      'nomVisiteur': nomVisiteur,
      'prenomVisiteur': prenomVisiteur,
      'emailVisiteur': emailVisiteur,
      'passwordVisiteur': passwordVisiteur,
      'telephoneVisiteur': telephoneVisiteur,
      'adresseVisiteur': adresseVisiteur,
    };
  }

  factory Visiteur.fromMap(Map<String, dynamic> map) {
    return Visiteur(
      idVisiteur: map['idVisiteur'] != null ? map['idVisiteur'] as int : null,
      nomVisiteur: map['nomVisiteur'] != null ? map['nomVisiteur'] as String : null,
      prenomVisiteur: map['prenomVisiteur'] != null ? map['prenomVisiteur'] as String : null,
      emailVisiteur: map['emailVisiteur'] != null ? map['emailVisiteur'] as String : null,
      passwordVisiteur: map['passwordVisiteur'] != null ? map['passwordVisiteur'] as String : null,
      telephoneVisiteur: map['telephoneVisiteur'] != null ? map['telephoneVisiteur'] as int : null,
      adresseVisiteur: map['adresseVisiteur'] != null ? map['adresseVisiteur'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Visiteur.fromJson(String source) => Visiteur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Visiteur(idVisiteur: $idVisiteur, nomVisiteur: $nomVisiteur, prenomVisiteur: $prenomVisiteur, emailVisiteur: $emailVisiteur, telephoneVisiteur: $telephoneVisiteur, adresseVisiteur: $adresseVisiteur)';
  }

  @override
  bool operator ==(covariant Visiteur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idVisiteur == idVisiteur &&
      other.nomVisiteur == nomVisiteur &&
      other.prenomVisiteur == prenomVisiteur &&
      other.emailVisiteur == emailVisiteur &&
      other.passwordVisiteur == passwordVisiteur &&
      other.telephoneVisiteur == telephoneVisiteur &&
      other.adresseVisiteur == adresseVisiteur;
  }

  @override
  int get hashCode {
    return idVisiteur.hashCode ^
      nomVisiteur.hashCode ^
      prenomVisiteur.hashCode ^
      emailVisiteur.hashCode ^
      passwordVisiteur.hashCode ^
      telephoneVisiteur.hashCode ^
      adresseVisiteur.hashCode;
  }
}

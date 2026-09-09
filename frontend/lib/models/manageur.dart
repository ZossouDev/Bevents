// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Manageur {
   int? idManageur;
   String? nomManageur;
   String? emailManageur;
   String? telManageur;
   int? idArtiste;
  Manageur({
    this.idManageur,
    this.nomManageur,
    this.emailManageur,
    this.telManageur,
    this.idArtiste,
  });

  Manageur copyWith({
    int? idManageur,
    String? nomManageur,
    String? emailManageur,
    String? telManageur,
    int? idArtiste,
  }) {
    return Manageur(
      idManageur: idManageur ?? this.idManageur,
      nomManageur: nomManageur ?? this.nomManageur,
      emailManageur: emailManageur ?? this.emailManageur,
      telManageur: telManageur ?? this.telManageur,
      idArtiste: idArtiste ?? this.idArtiste,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idManageur': idManageur,
      'nomManageur': nomManageur,
      'emailManageur': emailManageur,
      'telManageur': telManageur,
      'idArtiste': idArtiste,
    };
  }

  factory Manageur.fromMap(Map<String, dynamic> map) {
    return Manageur(
      idManageur: map['idManageur'] != null ? map['idManageur'] as int : null,
      nomManageur: map['nomManageur'] != null ? map['nomManageur'] as String : null,
      emailManageur: map['emailManageur'] != null ? map['emailManageur'] as String : null,
      telManageur: map['telManageur'] != null ? map['telManageur'] as String : null,
      idArtiste: map['idArtiste'] != null ? map['idArtiste'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Manageur.fromJson(String source) => Manageur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Manageur(idManageur: $idManageur, nomManageur: $nomManageur, emailManageur: $emailManageur, telManageur: $telManageur, idArtiste: $idArtiste)';
  }

  @override
  bool operator ==(covariant Manageur other) {
    if (identical(this, other)) return true;
  
    return 
      other.idManageur == idManageur &&
      other.nomManageur == nomManageur &&
      other.emailManageur == emailManageur &&
      other.telManageur == telManageur &&
      other.idArtiste == idArtiste;
  }

  @override
  int get hashCode {
    return idManageur.hashCode ^
      nomManageur.hashCode ^
      emailManageur.hashCode ^
      telManageur.hashCode ^
      idArtiste.hashCode;
  }
}

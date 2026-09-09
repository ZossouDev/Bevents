// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Espace {
 int? idEspace;
 String? nomEspace;
 String? descriptionEspace;
 int? capacite;
 int? prixEspace;
 String? disponibilite;
 String? imageEspace;
 String? adresseEspace;
  Espace({
    this.idEspace,
    this.nomEspace,
    this.descriptionEspace,
    this.capacite,
    this.prixEspace,
    this.disponibilite,
    this.imageEspace,
    this.adresseEspace,
  });

  Espace copyWith({
    int? idEspace,
    String? nomEspace,
    String? descriptionEspace,
    int? capacite,
    int? prixEspace,
    String? disponibilite,
    String? imageEspace,
    String? adresseEspace,
  }) {
    return Espace(
      idEspace: idEspace ?? this.idEspace,
      nomEspace: nomEspace ?? this.nomEspace,
      descriptionEspace: descriptionEspace ?? this.descriptionEspace,
      capacite: capacite ?? this.capacite,
      prixEspace: prixEspace ?? this.prixEspace,
      disponibilite: disponibilite ?? this.disponibilite,
      imageEspace: imageEspace ?? this.imageEspace,
      adresseEspace: adresseEspace ?? this.adresseEspace,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEspace': idEspace,
      'nomEspace': nomEspace,
      'descriptionEspace': descriptionEspace,
      'capacite': capacite,
      'prixEspace': prixEspace,
      'disponibilite': disponibilite,
      'imageEspace': imageEspace,
      'adresseEspace': adresseEspace,
    };
  }

  factory Espace.fromMap(Map<String, dynamic> map) {
    return Espace(
      idEspace: map['idEspace'] != null ? map['idEspace'] as int : null,
      nomEspace: map['nomEspace'] != null ? map['nomEspace'] as String : null,
      descriptionEspace: map['descriptionEspace'] != null ? map['descriptionEspace'] as String : null,
      capacite: map['capacite'] != null ? map['capacite'] as int : null,
      prixEspace: map['prixEspace'] != null ? map['prixEspace'] as int : null,
      disponibilite: map['disponibilite'] != null ? map['disponibilite'] as String : null,
      imageEspace: map['imageEspace'] != null ? map['imageEspace'] as String : null,
      adresseEspace: map['adresseEspace'] != null ? map['adresseEspace'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Espace.fromJson(String source) => Espace.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Espace(idEspace: $idEspace, nomEspace: $nomEspace, descriptionEspace: $descriptionEspace, capacite: $capacite, prixEspace: $prixEspace, disponibilite: $disponibilite, imageEspace: $imageEspace, adresseEspace: $adresseEspace)';
  }

  @override
  bool operator ==(covariant Espace other) {
    if (identical(this, other)) return true;
  
    return 
      other.idEspace == idEspace &&
      other.nomEspace == nomEspace &&
      other.descriptionEspace == descriptionEspace &&
      other.capacite == capacite &&
      other.prixEspace == prixEspace &&
      other.disponibilite == disponibilite &&
      other.imageEspace == imageEspace &&
      other.adresseEspace == adresseEspace;
  }

  @override
  int get hashCode {
    return idEspace.hashCode ^
      nomEspace.hashCode ^
      descriptionEspace.hashCode ^
      capacite.hashCode ^
      prixEspace.hashCode ^
      disponibilite.hashCode ^
      imageEspace.hashCode ^
      adresseEspace.hashCode;
  }
}

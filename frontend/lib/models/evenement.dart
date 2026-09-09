// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Evenement {
    int? idEvent;
    String? nomEvent;
    String? typeEvent;
    String? categorie;
    String? lieu;
    String? horaireDebut;
    String? imageEvent;
    String? descriptionEvent;
    int? nbrePlaces;
    String? prix;
    String? statut;
    int? idOrga;
  Evenement({
    this.idEvent,
    this.nomEvent,
    this.typeEvent,
    this.categorie,
    this.lieu,
    this.horaireDebut,
    this.imageEvent,
    this.descriptionEvent,
    this.nbrePlaces,
    this.prix,
    this.statut,
    this.idOrga,
  });

    Evenement? evenement;

  Evenement copyWith({
    int? idEvent,
    String? nomEvent,
    String? typeEvent,
    String? categorie,
    String? lieu,
    String? horaireDebut,
    String? imageEvent,
    String? descriptionEvent,
    int? nbrePlaces,
    String? prix,
    String? statut,
    int? idOrga,
  }) {
    return Evenement(
      idEvent: idEvent ?? this.idEvent,
      nomEvent: nomEvent ?? this.nomEvent,
      typeEvent: typeEvent ?? this.typeEvent,
      categorie: categorie ?? this.categorie,
      lieu: lieu ?? this.lieu,
      horaireDebut: horaireDebut ?? this.horaireDebut,
      imageEvent: imageEvent ?? this.imageEvent,
      descriptionEvent: descriptionEvent ?? this.descriptionEvent,
      nbrePlaces: nbrePlaces ?? this.nbrePlaces,
      prix: prix ?? this.prix,
      statut: statut ?? this.statut,
      idOrga: idOrga ?? this.idOrga,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEvent': idEvent,
      'nomEvent': nomEvent,
      'typeEvent': typeEvent,
      'categorie': categorie,
      'lieu': lieu,
      'horaireDebut': horaireDebut,
      'imageEvent': imageEvent,
      'descriptionEvent': descriptionEvent,
      'nbrePlaces': nbrePlaces,
      'prix': prix,
      'statut': statut,
      'idOrga': idOrga,
    };
  }

  factory Evenement.fromMap(Map<String, dynamic> map) {
    return Evenement(
      idEvent: map['idEvent'] != null ? map['idEvent'] as int : null,
      nomEvent: map['nomEvent'] != null ? map['nomEvent'] as String : null,
      typeEvent: map['typeEvent'] != null ? map['typeEvent'] as String : null,
      categorie: map['categorie'] != null ? map['categorie'] as String : null,
      lieu: map['lieu'] != null ? map['lieu'] as String : null,
      horaireDebut: map['horaireDebut'] != null ? map['horaireDebut'] as String : null,
      imageEvent: map['imageEvent'] != null ? map['imageEvent'] as String : null,
      descriptionEvent: map['descriptionEvent'] != null ? map['descriptionEvent'] as String : null,
      nbrePlaces: map['nbrePlaces'] != null ? map['nbrePlaces'] as int : null,
      prix: map['prix'] != null ? map['prix'] as String : null,
      statut: map['statut'] != null ? map['statut'] as String : null,
      idOrga: map['idOrga'] != null ? map['idOrga'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Evenement.fromJson(String source) => Evenement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Evenement(idEvent: $idEvent, nomEvent: $nomEvent, typeEvent: $typeEvent, categorie: $categorie, lieu: $lieu, horaireDebut: $horaireDebut, imageEvent: $imageEvent, descriptionEvent: $descriptionEvent, nbrePlaces: $nbrePlaces, prix: $prix, statut: $statut, idOrga: $idOrga)';
  }

  @override
  bool operator ==(covariant Evenement other) {
    if (identical(this, other)) return true;
  
    return 
      other.idEvent == idEvent &&
      other.nomEvent == nomEvent &&
      other.typeEvent == typeEvent &&
      other.categorie == categorie &&
      other.lieu == lieu &&
      other.horaireDebut == horaireDebut &&
      other.imageEvent == imageEvent &&
      other.descriptionEvent == descriptionEvent &&
      other.nbrePlaces == nbrePlaces &&
      other.prix == prix &&
      other.statut == statut &&
      other.idOrga == idOrga;
  }

  @override
  int get hashCode {
    return idEvent.hashCode ^
      nomEvent.hashCode ^
      typeEvent.hashCode ^
      categorie.hashCode ^
      lieu.hashCode ^
      horaireDebut.hashCode ^
      imageEvent.hashCode ^
      descriptionEvent.hashCode ^
      nbrePlaces.hashCode ^
      prix.hashCode ^
      statut.hashCode ^
      idOrga.hashCode;
  }
}

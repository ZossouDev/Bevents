// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bevent/models/evenement.dart';
import 'package:bevent/models/visiteur.dart';

class Commentaire {
    int? idCommentaire;
    String? contenu;
    String? dateCommentaire;
    int? idEvent;
    int? idVisiteur;

    Evenement? evenement;

    Visiteur? visiteur;
  Commentaire({
    this.idCommentaire,
    this.contenu,
    this.dateCommentaire,
    this.idEvent,
    this.idVisiteur,
    this.evenement,
    this.visiteur,
  });

  Commentaire copyWith({
    int? idCommentaire,
    String? contenu,
    String? dateCommentaire,
    int? idEvent,
    int? idVisiteur,
    Evenement? evenement,
    Visiteur? visiteur,
  }) {
    return Commentaire(
      idCommentaire: idCommentaire ?? this.idCommentaire,
      contenu: contenu ?? this.contenu,
      dateCommentaire: dateCommentaire ?? this.dateCommentaire,
      idEvent: idEvent ?? this.idEvent,
      idVisiteur: idVisiteur ?? this.idVisiteur,
      evenement: evenement ?? this.evenement,
      visiteur: visiteur ?? this.visiteur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCommentaire': idCommentaire,
      'contenu': contenu,
      'dateCommentaire': dateCommentaire,
      'idEvent': idEvent,
      'idVisiteur': idVisiteur,
      'evenement': evenement?.toMap(),
      'visiteur': visiteur?.toMap(),
    };
  }

  factory Commentaire.fromMap(Map<String, dynamic> map) {
    return Commentaire(
      idCommentaire: map['idCommentaire'] != null ? map['idCommentaire'] as int : null,
      contenu: map['contenu'] != null ? map['contenu'] as String : null,
      dateCommentaire: map['dateCommentaire'] != null ? map['dateCommentaire'] as String : null,
      idEvent: map['idEvent'] != null ? map['idEvent'] as int : null,
      idVisiteur: map['idVisiteur'] != null ? map['idVisiteur'] as int : null,
      evenement: map['evenement'] != null ? Evenement.fromMap(map['evenement'] as Map<String,dynamic>) : null,
      visiteur: map['visiteur'] != null ? Visiteur.fromMap(map['visiteur'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Commentaire.fromJson(String source) => Commentaire.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Commentaire(idCommentaire: $idCommentaire, contenu: $contenu, dateCommentaire: $dateCommentaire, idEvent: $idEvent, idVisiteur: $idVisiteur, evenement: $evenement, visiteur: $visiteur)';
  }

  @override
  bool operator ==(covariant Commentaire other) {
    if (identical(this, other)) return true;
  
    return 
      other.idCommentaire == idCommentaire &&
      other.contenu == contenu &&
      other.dateCommentaire == dateCommentaire &&
      other.idEvent == idEvent &&
      other.idVisiteur == idVisiteur &&
      other.evenement == evenement &&
      other.visiteur == visiteur;
  }

  @override
  int get hashCode {
    return idCommentaire.hashCode ^
      contenu.hashCode ^
      dateCommentaire.hashCode ^
      idEvent.hashCode ^
      idVisiteur.hashCode ^
      evenement.hashCode ^
      visiteur.hashCode;
  }
}

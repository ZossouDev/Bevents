// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Ticket {
     int? idTicket;
     int? nbreTicket;
     String? dateAchat;   
     int? montant;
  Ticket({
    this.idTicket,
    this.nbreTicket,
    this.dateAchat,
    this.montant,
  });

  Ticket copyWith({
    int? idTicket,
    int? nbreTicket,
    String? dateAchat,
    int? montant,
  }) {
    return Ticket(
      idTicket: idTicket ?? this.idTicket,
      nbreTicket: nbreTicket ?? this.nbreTicket,
      dateAchat: dateAchat ?? this.dateAchat,
      montant: montant ?? this.montant,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTicket': idTicket,
      'nbreTicket': nbreTicket,
      'dateAchat': dateAchat,
      'montant': montant,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      idTicket: map['idTicket'] != null ? map['idTicket'] as int : null,
      nbreTicket: map['nbreTicket'] != null ? map['nbreTicket'] as int : null,
      dateAchat: map['dateAchat'] != null ? map['dateAchat'] as String : null,
      montant: map['montant'] != null ? map['montant'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ticket(idTicket: $idTicket, nbreTicket: $nbreTicket, dateAchat: $dateAchat, montant: $montant)';
  }

  @override
  bool operator ==(covariant Ticket other) {
    if (identical(this, other)) return true;
  
    return 
      other.idTicket == idTicket &&
      other.nbreTicket == nbreTicket &&
      other.dateAchat == dateAchat &&
      other.montant == montant;
  }

  @override
  int get hashCode {
    return idTicket.hashCode ^
      nbreTicket.hashCode ^
      dateAchat.hashCode ^
      montant.hashCode;
  }
}

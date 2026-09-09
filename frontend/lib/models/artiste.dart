// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Artiste {
    int? idArtiste;
    String? nomArtiste;
    String? descriptionArtiste;    
    String? imageArtiste;
  Artiste({
    this.idArtiste,
    this.nomArtiste,
    this.descriptionArtiste,
    this.imageArtiste,
  });

  Artiste copyWith({
    int? idArtiste,
    String? nomArtiste,
    String? descriptionArtiste,
    String? imageArtiste,
  }) {
    return Artiste(
      idArtiste: idArtiste ?? this.idArtiste,
      nomArtiste: nomArtiste ?? this.nomArtiste,
      descriptionArtiste: descriptionArtiste ?? this.descriptionArtiste,
      imageArtiste: imageArtiste ?? this.imageArtiste,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idArtiste': idArtiste,
      'nomArtiste': nomArtiste,
      'descriptionArtiste': descriptionArtiste,
      'imageArtiste': imageArtiste,
    };
  }

  factory Artiste.fromMap(Map<String, dynamic> map) {
    return Artiste(
      idArtiste: map['idArtiste'] != null ? map['idArtiste'] as int : null,
      nomArtiste: map['nomArtiste'] != null ? map['nomArtiste'] as String : null,
      descriptionArtiste: map['descriptionArtiste'] != null ? map['descriptionArtiste'] as String : null,
      imageArtiste: map['imageArtiste'] != null ? map['imageArtiste'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artiste.fromJson(String source) => Artiste.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Artiste(idArtiste: $idArtiste, nomArtiste: $nomArtiste, descriptionArtiste: $descriptionArtiste, imageArtiste: $imageArtiste)';
  }

  @override
  bool operator ==(covariant Artiste other) {
    if (identical(this, other)) return true;
  
    return 
      other.idArtiste == idArtiste &&
      other.nomArtiste == nomArtiste &&
      other.descriptionArtiste == descriptionArtiste &&
      other.imageArtiste == imageArtiste;
  }

  @override
  int get hashCode {
    return idArtiste.hashCode ^
      nomArtiste.hashCode ^
      descriptionArtiste.hashCode ^
      imageArtiste.hashCode;
  }
}

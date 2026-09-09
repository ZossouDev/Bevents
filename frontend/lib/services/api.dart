import 'dart:convert';

import 'package:bevent/models/espace.dart';
import 'package:bevent/models/evenement.dart';
import 'package:bevent/models/organisateur.dart';
import 'package:bevent/services/urls.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<Organisateur>> getOrganisateur({String? id}) async {
    Map<String, dynamic> queryParameters = {
      "idOrga": id ?? "",
    };
    Uri url = Uri.http(Urls.urlServeur, Urls.urlOrganisateur, queryParameters);

    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["code"] == "100") {
          final listTemp = body["organisateur"];
          return listTemp.map<Organisateur>((item) => Organisateur.fromMap(item)).toList();
        } else {
          print("Erreur lors de la requête: ${response.statusCode}\n${response.body}");
          return [];
        }
      } else {
        print("Erreur lors de la requête: ${response.statusCode}\n${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception lors de la requête: $e");
      return [];
    }
  }

  // saveOrganisateur(Organisateur organisateur) {}

  // getStagiaire() {}

  // deleteOrganisateur(String string) {}

  // saveEspace(Espace espace, {required Map<String, http.MultipartFile> images}) {}

  // getEspace() {}

  // getEvenement() {}


Future<Map<String, dynamic>> saveOrganisateur(Organisateur organisateur) async {
    Uri url = Uri.http(Urls.urlServeur, Urls.urlOrganisateur);
    final dataToSend = organisateur.toMap();
    dataToSend.updateAll((key, value) => value ?? "");
    dataToSend.updateAll((key, value) => value.toString());
    dataToSend.updateAll((key, value) => value is Map<String, dynamic> ? "" : value);

    dataToSend.addAll({"action": "SAVE"});

    try {
      http.Response response = await http.post(url, body: dataToSend);
      
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> body = json.decode(response.body);
          if (body["code"] == "100") {
            return {"saved": true, "inserted_id": body["inserted_id"], "message_error": null};
          } else {
            return {"saved": false, "message_error": body["message"]};
          }
        } else {
          print('Réponse vide');
          return {"saved": false, "message_error": "Réponse vide du serveur"};
        }
      } else {
        return {"saved": false, "message_error": "Une erreur s'est produite (Statut: ${response.statusCode})"};
      }
    } catch (e) {
      print("Exception lors de la requête: $e");
      return {"saved": false, "message_error": "Une erreur s'est produite: $e"};
    }
  }

    Future<Map<String, dynamic>> deleteOrganisateur(String id) async {
    Uri url = Uri.http(Urls.urlServeur, Urls.urlOrganisateur);

    try {
      http.Response response = await http.post(url, body: {"action": "DELETE", "idOrga": id});
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        if (body["code"] == "100") {
          return {"deleted": true, "message_error": null};
        } else {
          return {"deleted": false, "message_error": body["message"]};
        }
      } else {
        return {
          "deleted": false,
          "message_error": "Une erreur s'est produite lors de la suppression"
        };
      }
    } catch (e) {
      print("Exception lors de la requête de suppression: $e");
      return {
        "deleted": false,
        "message_error": "Une erreur s'est produite lors de la suppression"
      };
    }
  }

Future<List<Evenement>> getEvenement({String? idEvent, String? idOrga}) async {
  Map<String, dynamic> queryParameters = {
    "idEvent": idEvent ?? "",
    "idOrga": idOrga ?? "",
  };
  Uri url = Uri.http(Urls.urlServeur, Urls.urlEvenement, queryParameters);

  try {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body["code"] == "100") {
        final listTemp = body["evenement"];
        return listTemp.map<Evenement>((item) => Evenement.fromMap(item)).toList();
      } else {
        print("Erreur lors de la requête: ${response.statusCode}\n${response.body}");
        return [];
      }
    } else {
      print("Erreur lors de la requête: ${response.statusCode}\n${response.body}");
      return [];
    }
  } catch (e) {
    print("Exception lors de la requête: $e");
    return [];
  }
}



Future<Map<String, dynamic>> saveEvenement(
    Evenement evenement, {
    Map<String, http.MultipartFile>? images,
  }) async {
    Uri url = Uri.http(Urls.urlServeur, Urls.urlEvenement);
    final dataToSend = evenement.toMap();
    dataToSend.updateAll((key, value) => value ?? "");
    dataToSend.updateAll((key, value) => value.toString());
    dataToSend.updateAll((key, value) => value is Map<String, dynamic> ? "" : value);

    dataToSend.addAll({"action": "SAVE"});

    List<String> keys = [];
    List<String> values = [];
    Map<String, String> fields = {};

    keys.addAll((dataToSend).keys);
    values.addAll((dataToSend).values.map((e) => "$e").toList());

    var request = await http.MultipartRequest('POST', url);

    for (int i = 0; i < keys.length; i++) {
      fields[keys[i]] = values[i];
    }

    request.fields.addAll(fields);

    if (images != null && images.isNotEmpty) {
      request.files.addAll(images.values);
    }

    try {
      http.StreamedResponse response = await request.send();
      var stream = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(stream);

        if (body["code"] == "100") {
          return {"saved": true, "inserted_id": body["inserted_id"], "message_error": null};
        } else {
          return {"saved": false, "message_error": body["message"]};
        }
      } else {
        return {"saved": false, "message_error": "Une erreur s'est produite"};
      }
    } catch (e) {
      print("Exception lors de la requête: $e");
      return {"saved": false, "message_error": "Une erreur s'est produite"};
    }
  }

   Future<Map<String, dynamic>> deleteEvenement(int idEvent) async {
    Uri url = Uri.http(Urls.urlServeur, Urls.urlEvenement);
    try {
      http.Response response =
          await http.post(url, body: {"action": "DELETE", "id": idEvent.toString()});
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        if (body["code"] == "100") {
          return {"deleted": true, "message_error": null};
        } else {
          return {"deleted": false, "message_error": body["message"]};
        }
      } else {
        return {
          "deleted": false,
          "message_error": "Une erreur s'est produite lors de la suppression du Enenement"
        };
      }
    } catch (e) {
      print("Exception lors de la requête de suppression du Enenement: $e");
      return {
        "deleted": false,
        "message_error": "Une erreur s'est produite lors de la suppression du Enenement"
      };
    }
  }

Future<List<Espace>> getEspace({String? idEspace}) async {
  Map<String, dynamic> queryParameters = {
    "idEspace": idEspace ?? "",
  };
  Uri url = Uri.http(Urls.urlServeur, Urls.urlEspace, queryParameters);

  try {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body["code"] == "100") {
        final listTemp = body["espace"] as List;
        return listTemp.map<Espace>((item) => Espace.fromMap(item)).toList();
      } else {
        print("Erreur lors de la requête: ${response.statusCode}\n${response.body}");
        return [];
      }
    } else {
      print("Erreur lors de la requête: ${response.statusCode}\n${response.body}");
      return [];
    }
  } catch (e) {
    print("Exception lors de la requête: $e");
    return [];
  }
}




Future<Map<String, dynamic>> saveEspace(
  Espace espace, {
  Map<String, http.MultipartFile>? images,
}) async {
  Uri url = Uri.http(Urls.urlServeur, Urls.urlEspace);
  final dataToSend = espace.toMap();
  dataToSend.updateAll((key, value) => value ?? "");
  dataToSend.updateAll((key, value) => value.toString());
  dataToSend.updateAll((key, value) => value is Map<String, dynamic> ? "" : value);

  dataToSend.addAll({"action": "SAVE"});

  List<String> keys = [];
  List<String> values = [];
  Map<String, String> fields = {};

  keys.addAll(dataToSend.keys);
  values.addAll(dataToSend.values.map((e) => "$e").toList());

  var request = http.MultipartRequest('POST', url);

  for (int i = 0; i < keys.length; i++) {
    fields[keys[i]] = values[i];
  }

  request.fields.addAll(fields);

  if (images != null && images.isNotEmpty) {
    request.files.addAll(images.values);
  }

  try {
    http.StreamedResponse response = await request.send();
    var stream = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(stream);

      if (body["code"] == "100") {
        return {"saved": true, "inserted_id": body["inserted_id"], "message_error": null};
      } else {
        return {"saved": false, "message_error": body["message"]};
      }
    } else {
      return {"saved": false, "message_error": "Une erreur s'est produite"};
    }
  } catch (e) {
    print("Exception lors de la requête: $e");
    return {"saved": false, "message_error": "Une erreur s'est produite"};
  }
}

   Future<Map<String, dynamic>> deleteEspace(int idEspace) async {
    Uri url = Uri.http(Urls.urlServeur, Urls.urlEspace);
    try {
      http.Response response =
          await http.post(url, body: {"action": "DELETE", "id": idEspace.toString()});
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        if (body["code"] == "100") {
          return {"deleted": true, "message_error": null};
        } else {
          return {"deleted": false, "message_error": body["message"]};
        }
      } else {
        return {
          "deleted": false,
          "message_error": "Une erreur s'est produite lors de la suppression du Enenement"
        };
      }
    } catch (e) {
      print("Exception lors de la requête de suppression du Enenement: $e");
      return {
        "deleted": false,
        "message_error": "Une erreur s'est produite lors de la suppression du Enenement"
      };
    }
  }

  // Ajoutez la méthode updateEvenement à votre classe Api
 Future<bool> updateEventStatus(int eventId, String newStatus) async {
    try {
      final response = await http.put(
        Urls.apiUri('evenement.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'statut': newStatus, 'idEvent': eventId, "action": "SAVE"}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating event status: $e');
      return false;
    }
  }

  }

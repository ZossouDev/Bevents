import 'package:bevent/pages/acceuil/home.dart';
import 'package:bevent/pages/dashbordorganisateur/mes%20espaces/espace.dart';
import 'package:bevent/pages/dashbordorganisateur/mes%20evenements/meseventsPage.dart';
import 'package:bevent/pages/dashbordorganisateur/organisateur/organisateurPage.dart';
import 'package:bevent/services/urls.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Page {
  String nom;
  Widget page;

  Page({required this.nom, required this.page});
}

class HomePage2 extends StatefulWidget {
  final int? id;

  const HomePage2({super.key, this.id});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int currentIndex = 0;
  String selectedItem = 'Mon Dashboard'; // Élément de menu sélectionné par défaut
  List<Page> pages = [];

  void setPages() {
    setState(() {
      pages.addAll([
        Page(
          nom: "Mon Dashboard",
          page: dashboard(),
        ),
        Page(
          nom: "Mes Evenements",
          page: MesEvenement(id: widget.id),
        ),
        Page(
          nom: "Les Espaces",
          page: EspacePage(),
        ),
      ]);
      selectedPage = pages[currentIndex];
    });
  }

  Page? selectedPage;

  String? userName;
  String? userLastName;

  @override
  void initState() {
    super.initState();
    setPages();
    fetchOrganisateurData(idOrga: widget.id);
  }

  Future<void> fetchOrganisateurData({int? idOrga}) async {
    // Envoyer une requête HTTP POST pour se connecter à l'API et récupérer les données de l'organisateur
    var response = await http.get(
      Urls.apiUri('register.php', queryParameters: {'idOrga': '$idOrga'}),
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 200) {
      // Convertir la réponse en JSON
      Map<String, dynamic> responseJson = json.decode(response.body);
      print(response.request!.url);

      // Vérifier si la connexion a réussi
      if (responseJson['codeReponse'] == "100") {
        // Récupérer les données de l'organisateur
        print("La fonction fetchOrganisateurData est appelée !");
        print("b ${response.body}");
        Map<String, dynamic> organisateur = (responseJson['organisateur'] as List).first;
        setState(() {
          userName = organisateur['nomOrga'];
          userLastName = organisateur['prenomOrga'];
        });
      } else {
        // Gérer les autres cas de réponse de l'API (erreur d'identification, etc.)
      }
    } else {
      // Gérer les erreurs de réseau
    }
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Voulez-vous vraiment vous déconnecter?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => home()), // Rediriger vers la page de login
                );
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  Widget buildMenuItem(String title, VoidCallback onTap, {Color color = Colors.white}) {
    return Stack(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: selectedItem == title ? color : Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              selectedItem = title; // Mettre à jour l'élément de menu sélectionné
              if (title != 'Déconnexion') {
                selectedPage = pages.firstWhere((element) => element.nom == title);
              } else {
                showLogoutDialog();
              }
            });
            onTap(); // Appeler la fonction associée à l'élément de menu sélectionné
          },
          tileColor: selectedItem == title ? color.withOpacity(0.2) : Color.fromARGB(255, 11, 1, 56),
          contentPadding: EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(selectedItem == title ? 20 : 0),
              bottomRight: Radius.circular(selectedItem == title ? 20 : 0),
            ),
          ),
        ),
        if (selectedItem == title)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                color: color.withOpacity(0.5),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si userName est null, afficher un texte générique
    String displayName = userName ?? 'Utilisateur';
    String displayLastName = userLastName ?? '';

    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              width: 200,
              child: Drawer(
                child: Container(
                  color: Color.fromARGB(255, 11, 1, 56),
                  child: Column(
                    children: [
                      DrawerHeader(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/zyro.png",
                              height: 100,
                            ),
                            //SizedBox(height: 5.0),
                            Text(
                              '$displayName $displayLastName',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            buildMenuItem('Mon Dashboard', () {}, color: Colors.orange),
                            buildMenuItem('Mes Evenements', () {}, color: Colors.orange),
                            buildMenuItem('Les Espaces', () {}, color: Colors.orange),
                            buildMenuItem('Déconnexion', showLogoutDialog, color: Colors.orange),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: selectedPage != null ? selectedPage!.page : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

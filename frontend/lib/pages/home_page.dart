import 'package:bevent/pages/acceuil/home.dart';
import 'package:bevent/pages/dashbordadmin/administrateur/administrateurPage.dart';
import 'package:bevent/pages/dashbordadmin/espace/espacePage.dart';
import 'package:bevent/pages/dashbordadmin/evenement/evenementPage.dart';
import 'package:bevent/pages/dashbordadmin/orga/orgaListes.dart';
import 'package:flutter/material.dart';

class Page {
  String nom;
  Widget page;

  Page({required this.nom, required this.page});
}

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  int currentIndex = 0;

  List<Page> pages = [
    Page(
      nom: "Mon Dashboard",
      page: dashboardadmin(),
    ),
    Page(
      nom: "Organisateurs",
      page: OrganisateurListPage(),
    ),
    Page(
      nom: "Espaces",
      page: EspaceListPage(),
    ),
    Page(
      nom: "Evenements",
      page: EvenementListPage(),
    ),
  ];

  Page? selectedPage;

  @override
  void initState() {
    selectedPage = pages[currentIndex];
    super.initState();
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

  Widget buildMenuItem(String title, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: selectedPage?.nom == title ? Colors.orange : Colors.white, // Utiliser la couleur orange pour l'élément sélectionné
        ),
      ),
      onTap: () {
        if (title != 'Déconnexion') {
          setState(() {
            selectedPage = pages.firstWhere((element) => element.nom == title);
          });
        } else {
          showLogoutDialog();
        }
        onTap?.call(); // Appeler la fonction onTap si elle est non null
      },
      tileColor: selectedPage?.nom == title ? Color.fromARGB(255, 10, 50, 80) : Color.fromARGB(255, 11, 1, 56), // Utiliser une couleur de fond différente pour l'élément sélectionné
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            Text(
                              'Administrateur',
                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ...pages.map(
                              (e) => buildMenuItem(
                                e.nom,
                                onTap: () {
                                  setState(() {
                                    selectedPage = e;
                                  });
                                },
                              ),
                            ),
                            buildMenuItem('Déconnexion', onTap: () {}),
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

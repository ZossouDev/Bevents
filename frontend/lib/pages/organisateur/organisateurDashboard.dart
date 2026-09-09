import 'package:bevent/pages/organisateur/OrganisateurDetail/mes_events.dart';
import 'package:bevent/pages/organisateur/OrganisateurDetail/profil.dart';
import 'package:bevent/pages/organisateur/OrganisateurDetail/statistiques.dart';
import 'package:bevent/services/urls.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class dashbord extends StatelessWidget {
  final int? id;

  const dashbord({super.key, this.id});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(id: id),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final int? id;

  const DashboardPage({super.key, this.id});
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool evenementsExpanded = false;
  String selectedMenu = '';

 Widget page=EventStatisticsPage(); // Utilisation de la page des statistiques comme page par défaut

  String? userName;
  String? userLastName;

 @override
  void initState() {
    super.initState();
    // Appeler la méthode pour récupérer les données de l'organisateur une fois que le widget est créé
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

  @override
  Widget build(BuildContext context) {
    // Si userName est null, afficher un texte générique
    String displayName = userName ?? 'Utilisateur';
    String displayLastName = userLastName ?? '';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 50, 80),
        ),
        child: Row(
          children: [
            Container(
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100.0,
                    width: double.infinity,
                    color: Colors.orange, // Appliquer l'arrière-plan bleu ici
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                                  height: 50,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/zyro1.png"),
                                  fit:BoxFit.cover)
                                ),
                                 ),
                        SizedBox(width: 10.0),
                        Text(
                          '$displayName $displayLastName',
                         style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                   color: Colors.white,
                  ),
                 // SizedBox(height: 10.0,),
                  buildMenuItem(Icons.screenshot_monitor_outlined, 'Dashbord', 'dashbord'),
                  Divider(
                   color: Colors.white,
                  ),
                  buildMenuItem(Icons.calendar_today_outlined, 'Mes Evenements', 'mes_evenements'),
                  buildMenuItem(Icons.add_home_work_outlined, 'Espaces', 'espaces'),
                  buildMenuItem(Icons.person_3_outlined, 'Mon profil', 'profil'),
                  buildMenuItem(Icons.recycling_rounded, 'Retour au site public', 'retour_site'),
                  buildMenuItem(Icons.exit_to_app, 'Deconnexion', 'deconnexion'),
                ],
              ),
            ),
          
          Expanded(
              child: Container(
                color: const Color.fromARGB(255, 207, 207, 207),
                child: Column(
                  children: [
                    Container(
                      height: 100.0,
                      width: double.infinity,
                      color: Colors.orange,
                   child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.person, 
                              color: Colors.white,
                              size: 40.0),
                            onSelected: (value) {
                              navigateTo(value);
                            },
                    itemBuilder: (BuildContext context) {
                                      return [
                        const PopupMenuItem<String>(
                          value: 'profil',
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.orange,),
                              SizedBox(width: 8.0),
                              Text('Profil'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app, color: Colors.orange,),
                              SizedBox(width: 8.0),
                              Text('Déconnexion'),
                            ],
                          ),
                        ),
                      ];
                    },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: page,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildMenuItem(IconData icon, String title, String menu) {
    return ListTile(
      leading: Icon(icon, color: selectedMenu == menu ? Colors.orange : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: selectedMenu == menu ? Colors.orange : Colors.white,
        ),
      ),
      onTap: () {
        setState(() {
          selectedMenu = menu;
          switch (menu) {
            case 'dashbord':
              page = EventStatisticsPage(id: widget.id);
              break;
            // case 'mes_evenements':
            //   page = MesEvenementsPage(id: widget.id);
            //   break;
            case 'profil':
              page = profil();
              break;
            case 'retour_site':
              // Gérer le retour au site public
              break;
            case 'deconnexion':
              showLogoutConfirmationDialog(context);
              break;
          }
        });
      },
    );
  }

void navigateTo(String destination) {
    switch (destination) {
      case 'profil':
              page = profil();
              break;
      case 'logout':
        showLogoutConfirmationDialog(context);
        break;
    }
  }



void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                // Mettez ici la logique pour se déconnecter
                // Après la déconnexion, vous pouvez naviguer vers la page d'accueil
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

}






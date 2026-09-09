import 'dart:convert';
import 'package:bevent/pages/acceuil/contact.dart';
import 'package:bevent/services/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class dashboard extends StatefulWidget {
  final int? id;

  const dashboard({super.key, this.id});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  bool hasOpenProfileMenu = false;
  String? userLastName;

  @override
  void initState() {
    super.initState();
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
        Map<String, dynamic> organisateur = (responseJson['organisateur'] as List).first;
        setState(() {
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
    String displayName = userLastName ?? '';

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 171, 169),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              // Première ligne avec les deux cartes
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 11, 1, 56),
                            Colors.orange
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      height: 400,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Bonjour $displayName !", // Utilisez le prénom de l'utilisateur ici
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: '\n\n'),
                                TextSpan(
                                  text: 'Bienvenue sur votre dashbord ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                TextSpan(text: '\n\n'),
                                TextSpan(
                                  text:
                                      'Vous avez maintenant accès à toutes les fonctionnalités de notre plateforme pour planifier, promouvoir et gérer vos événements de manière efficace. ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                TextSpan(text: '\n\n'),
                                TextSpan(
                                  text:
                                      'N\'hésitez pas à nous contacter si vous avez des questions ou des suggestions pour améliorer notre service. ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Bouton dans le Container
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => contact()),
                              );
                            },
                            child: Text(
                              'Contactez-nous',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 11, 1, 56),
                            Colors.orange
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      height: 400,
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StatisticCard(
                                title: 'Nombres evenements organisés',
                                value: '00',
                                icon: Icons.event,
                              ),
                              Divider(),
                              StatisticCard(
                                title: 'Nombres de participants',
                                value: '00',
                                icon: Icons.people,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 45, // Adjust the radius to make the CircleAvatar larger or smaller
          backgroundColor: Color.fromARGB(255, 12, 6, 43),
          child: Icon(icon, size: 50, color: Colors.orange),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: dashboard(),
  ));
}

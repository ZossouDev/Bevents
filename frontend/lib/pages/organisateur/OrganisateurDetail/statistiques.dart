
import 'dart:convert';
import 'package:bevent/pages/acceuil/contact.dart';
import 'package:bevent/services/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:beevent/pages/organisateur/organisateurDashboard.dart;


class EventStatisticsPage extends StatefulWidget {
  final int? id;

  const EventStatisticsPage({super.key, this.id});


  @override
  _EventStatisticsPageState createState() => _EventStatisticsPageState();
}

class _EventStatisticsPageState extends State<EventStatisticsPage> {
  String? userLastName;

  @override
  void initState() {
    super.initState();
    fetchOrganisateurData(idOrga: widget.id);
  }

  Future<void> fetchOrganisateurData({int? idOrga}) async{
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
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              // Première ligne avec les deux cartes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 10, 50, 80),
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
                            child: Text('Contactez-nous'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                             StatisticCard(
                              title: 'Nombres evenements organisés',
                              value: '00',
                            ),
                            Divider(),
                            StatisticCard(
                              title: 'Nombres de participants',
                              value: '00',
                            ),
                            Divider(),
                            StatisticCard(
                              title: '',
                              value: '',
                            ),
                          ],
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

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EventStatisticsPage(),
  ));
}

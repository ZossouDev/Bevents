import 'package:flutter/material.dart';
import 'modifier_profil.dart'; // Importez la classe ModifierProfilPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? userName;
  String? userLastName;
  String? userEmail;

  @override
   void initState() {
     super.initState();
     getCurrentUser();
   }

  void getCurrentUser() async {
    User? user= FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(uid)
          .get();

      setState(() {
        userName = userSnapshot['nomUser'];
        userLastName = userSnapshot['prenomUser'];
        userEmail = userSnapshot['emailUser'];
      });
    }
  }
  // Ajoutez vos contrôleurs ici pour les champs que vous souhaitez modifier
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  // Ajoutez vos variables pour les centres d'intérêt
  List<String> centresInterets = ['Voyages', 'Photographie', 'Cuisine', 'Sport'];
  List<bool> isSelected = [false, false, false, false]; // Initialisation des sélections

  @override
  Widget build(BuildContext context) {
    String displayName = userName ?? '';
    String displayLastName = userLastName ?? '';
    String displayEmail = userEmail ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Card d'informations sur l'utilisateur
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        // backgroundImage: NetworkImage('https://example.com/user_profile.jpg'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text('Nom: $displayName', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('Prénom: $displayLastName', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('Numéro:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('E-mail: $displayEmail', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('Adresse:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('Dernière connexion:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Naviguer vers la page de modification en passant les contrôleurs
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierProfilPage(
                                nomController: nomController,
                                prenomController: prenomController,
                                numeroController: numeroController,
                                emailController: emailController,
                                adresseController: adresseController,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 10, 50, 80), // Couleur du fond du bouton
                        ),
                        child: Text('Modifier profil', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  ),
                  // Ajoutez d'autres informations ici...
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          // Card des centres d'intérêts
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Centres d\'intérêts',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Liste des centres d'intérêt
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      for (int i = 0; i < centresInterets.length; i++)
                        ElevatedButton(
                          onPressed: () {
                            // Gérer la sélection du centre d'intérêt
                            setState(() {
                              isSelected[i] = !isSelected[i];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected[i] ? Colors.blue : null, // Couleur du fond du bouton
                          ),
                          child: Text(centresInterets[i]),
                        ),
                      // Ajoutez d'autres centres d'intérêts ici...
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

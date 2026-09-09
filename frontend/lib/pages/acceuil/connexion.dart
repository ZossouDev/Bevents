import 'dart:convert';
import 'package:bevent/pages/acceuil/forget.dart';
import 'package:bevent/pages/acceuil/inscription.dart';
import 'package:bevent/pages/home_page2.dart';
import 'package:bevent/pages/organisateur/organisateurDashboard.dart';
import 'package:bevent/services/urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../home_page.dart';


class connect extends StatefulWidget {
  @override
  _connectState createState() => _connectState();
}
class _connectState extends State<connect>  {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailErrorText;
  String? _passwordErrorText;

Future<void> _signIn() async {  
  print("La fonction _signIn est appelée !");  
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      final String email = _emailController.text;
      final String password = _passwordController.text;

      // URL de votre API
      final Uri apiUrl = Urls.apiUri('register.php');
          try {
      final response = await http.post(apiUrl,
        body: {
          'action': 'login',
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String codeResponse = responseData['codeResponse'];
        if (codeResponse == "100") {
          // Connexion réussie
          //final String role = responseData['organisateur']['role'];
          final String role = responseData.containsKey('administrateur') ? responseData['administrateur']['role'] : '';

          if (role == 'administrateur') {
            // Rediriger l'administrateur vers le dashbordadmin
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage1()),
            );
          } else {            
            // Rediriger l'organisateur vers le dashbord
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage2(id: responseData['organisateur']['idOrga'])),
            );
          }
        } else {
          // Identifiants incorrects, afficher un message d'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur de connexion: Identifiants incorrects'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        throw Exception('Failed to login user');
      }
    } catch (error) {
      // Gérer les erreurs
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 800,
              width: double.infinity,
              decoration: const BoxDecoration(
                 color: Color.fromARGB(255, 11, 1, 56),
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/zyro.png"),
                      ),
                    ),
                  ),
                  Container(
                    height: 450,
                    width: 500,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email',
                              errorText: _emailErrorText,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Mot de passe',
                              errorText: _passwordErrorText,
                              ),
                            ),
                            SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  forget()),
                                );
                                },
                                child: Text('Mot de passe oublié?',style: TextStyle(fontSize:15, color: Colors.red),),
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(child:
                                ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange, // Couleur du fond du bouton
                                  ),
                                  child: Text('Connexion', style: TextStyle(fontSize:20, color: Colors.white),),
                                ),
                                ),
                              ],
                            ),
                            SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Vous n'avez pas de compte?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  inscription()),
                                );
                                  },
                                  child: Text('Créer un compte'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

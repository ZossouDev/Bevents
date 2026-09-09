import 'dart:convert';
import 'package:bevent/pages/acceuil/connexion.dart';
import 'package:bevent/services/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



 class inscription extends StatefulWidget {
  const inscription({super.key});

  @override
  State<inscription> createState() => _inscriptionState();
}

class _inscriptionState extends State<inscription> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                        height: 500,
                        width: 500,
                        child: Card(
                           color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[  
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _nomController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Entrez le nom",
                                prefixIcon: const Icon(Icons.person_outlined),
                                contentPadding: const EdgeInsets.only(top: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 3.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff9DD1F1), width: 3.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'S\'il vous plaît entrez le nom';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _prenomController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Entrez le prénom",
                                prefixIcon: const Icon(Icons.person_outlined),
                                contentPadding: const EdgeInsets.only(top: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff9DD1F1), width: 3.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'S\'il vous plaît entrez le prénom';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Entrez Email",
                                prefixIcon: const Icon(Icons.email_outlined),
                                contentPadding: const EdgeInsets.only(top: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff9DD1F1), width: 3.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@gmail.com')) {
                                  return 'S\'il vous plâit entrez l\'email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Mot de passe ",
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                contentPadding: const EdgeInsets.only(top: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff9DD1F1), width: 3.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value == "" ||
                                    value.length < 6) {
                                  return 'Entrez un mot de passe de 6 caractères au moins';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Confirmez le mot de passe",
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                contentPadding: const EdgeInsets.only(top: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xff9DD1F1), width: 3.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Entrez un mot de passe de 6 caractères au moins';
                                }
                                if (value != _passwordController.text) {
                                  return 'Les mots de passe ne sont pas identiques';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(child: 
                                ElevatedButton(
                                  onPressed: _registerUser,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange, // Couleur du fond du bouton
                                  ),
                                  child: const Text('Valider', style: TextStyle(fontSize:20, color: Colors.white),),
                                ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      ]
                        ),
                      )
                        ),
                      )
                      ]
                      ),
                    ),
                    ],
              ),
            )
    );
  }
  void _registerUser() async {
      print("La fonction _registerUser est appelée !");
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
  if (_formKey.currentState!.validate()) {
    // Récupération des valeurs des champs
    String nom = _nomController.text;
    String prenom = _prenomController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    
    // Appel à votre API pour l'inscription
    var response = await registerOrganisateur(nom, prenom, email, password);
    
    // Traitement de la réponse de l'API
    var codeReponse = response['codeResponse'];
    if (codeReponse == "100") {
      // Affichage d'un message de succès
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inscription réussie"),
        backgroundColor: Colors.green,
      ));
     _showConnectDialog(context);
      
      // Vous pouvez rediriger l'utilisateur vers une autre page ou effectuer d'autres actions ici
    } else {
      // Affichage d'un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de l'inscription"),
        backgroundColor: Colors.red,
      ));
    }
  }
}

// Fonction pour afficher la boîte de dialogue AlertDialog
static void _showConnectDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Inscription réussie'),
      content: Text('Appuyez sur OK pour vous connecter'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => connect()));
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

// Fonction pour appeler votre API d'inscription
Future<Map<String, dynamic>> registerOrganisateur(String nom, String prenom, String email, String password) async {
  final response = await http.post(Urls.apiUri('register.php'), body: {
    'action': 'register',
    'nomOrga': nom,
    'prenomOrga': prenom,
    'emailOrga': email,
    'passwordOrga': password,
  });
  return json.decode(response.body);
}

}

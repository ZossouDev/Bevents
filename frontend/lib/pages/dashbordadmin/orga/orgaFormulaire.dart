import 'package:bevent/models/organisateur.dart';
import 'package:bevent/services/api.dart';
import 'package:flutter/material.dart';

class OrganisateurFormulairePage extends StatefulWidget {
  final Organisateur? organisateur;
  final void Function() onSuccess;

  const OrganisateurFormulairePage({super.key, this.organisateur, required this.onSuccess});

  @override
  State<OrganisateurFormulairePage> createState() => _OrganisateurFormulairePageState();
}

class _OrganisateurFormulairePageState extends State<OrganisateurFormulairePage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.organisateur != null) {
      nomController.text = widget.organisateur!.nomOrga!;
      prenomController.text = widget.organisateur!.prenomOrga!;
      emailController.text = widget.organisateur!.emailOrga!;
      passwordController.text = widget.organisateur!.passwordOrga!;
      telephoneController.text = widget.organisateur!.telephoneOrga!.toString();
      adresseController.text = widget.organisateur!.adresseOrga!;
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Formulaire organisateur',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  if (!value.contains('@')) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un numéro de téléphone valide';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: adresseController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: isLoading
      ? null
      : () async {
          if (formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });

            final organisateur = Organisateur(
              idOrga: widget.organisateur?.idOrga,
              nomOrga: nomController.text,
              prenomOrga: prenomController.text,
              emailOrga: emailController.text,
              telephoneOrga: int.parse(telephoneController.text), // Conversion de String à int
              adresseOrga: adresseController.text,
              passwordOrga: passwordController.text,
            );

            print('Envoi de la requête pour sauvegarder l\'organisateur');
            try {
              var resultat = await Api().saveOrganisateur(organisateur);
              print('Réponse de l\'API : $resultat');
              if (resultat['saved']) {
                Navigator.pop(context);
                widget.onSuccess();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Erreur lors de l\'enregistrement: ${resultat['message_error']}',
                    ),
                  ),
                );
              }
            } catch (e) {
              print('Erreur lors de la sauvegarde : $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Une erreur s\'est produite : $e',
                  ),
                ),
              );
            }

            setState(() {
              isLoading = false;
            });
          }
        },
  child: isLoading
      ? CircularProgressIndicator(color: Colors.white)
      : Text("Enregistrer"),
)

          ],
        ),
      ),
      ),
    );
  }
}

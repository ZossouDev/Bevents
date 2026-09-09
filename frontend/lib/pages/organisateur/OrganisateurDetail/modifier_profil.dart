import 'dart:io';  // N'oubliez pas d'importer dart:io

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModifierProfilPage extends StatefulWidget {
  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController numeroController;
  final TextEditingController emailController;
  final TextEditingController adresseController;

  ModifierProfilPage({
    required this.nomController,
    required this.prenomController,
    required this.numeroController,
    required this.emailController,
    required this.adresseController,
  });

  @override
  _ModifierProfilPageState createState() => _ModifierProfilPageState();
}

class _ModifierProfilPageState extends State<ModifierProfilPage> {
  // Ajoutez un contrôleur pour le chemin de l'image
  late TextEditingController imageController;
  late ImagePicker _picker;

  // Fonction pour choisir une image depuis la galerie
  Future<void> pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Mettez à jour le contrôleur de l'image avec le nouveau chemin
      imageController.text = pickedFile.path;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser le contrôleur de l'image
    imageController = TextEditingController();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder pour l'image avec la possibilité de choisir une nouvelle image
            InkWell(
              onTap: () {
                pickImage();
              },
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(75.0),
                  image: imageController.text.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(
                            File(imageController.text),
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageController.text.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 40.0,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 10.0),
            // Ajoutez les champs de modification ici avec les contrôleurs
            TextField(controller: widget.nomController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: widget.prenomController, decoration: InputDecoration(labelText: 'Prénom')),
            TextField(controller: widget.numeroController, decoration: InputDecoration(labelText: 'Numéro')),
            TextField(controller: widget.emailController, decoration: InputDecoration(labelText: 'E-mail')),
            TextField(controller: widget.adresseController, decoration: InputDecoration(labelText: 'Adresse')),
            
            SizedBox(height: 10.0),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Ajoutez ici la logique pour enregistrer la modification
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Couleur du fond du bouton
                                  ),
                                  child: Text('Confirmer', style: TextStyle(fontSize:20, color: Colors.white),),
                                ),
                              ],
                            ),
          ],
        ),
      ),
    );
  }
}

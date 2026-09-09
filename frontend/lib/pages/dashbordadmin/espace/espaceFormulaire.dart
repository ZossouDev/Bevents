import 'dart:io';

import 'package:bevent/models/espace.dart';
import 'package:bevent/services/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EspaceFormulairePage extends StatefulWidget {
  final Espace? espace;
  final void Function() onSuccess;
  const EspaceFormulairePage({super.key, this.espace, required this.onSuccess});

  @override
  State<EspaceFormulairePage> createState() => _EspaceFormulairePageState();
}

class _EspaceFormulairePageState extends State<EspaceFormulairePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController capaciteController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  XFile? image;

  ImagePicker picker = ImagePicker();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.espace != null) {
      nomController.text = widget.espace!.nomEspace!;
      descriptionController.text = widget.espace!.descriptionEspace!;
      capaciteController.text = widget.espace!.capacite.toString();
      prixController.text = widget.espace!.prixEspace.toString();
      adresseController.text = widget.espace!.adresseEspace.toString();
    }
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
            if (image != null)
              Card(
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  File(image!.path).uri.toFilePath(),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  image = selectedImage;
                });
              },
              child: image == null ? const Text('Ajouter une Image') : const Text('Changer l\'Image'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom Espace',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description Espace',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: capaciteController,
              decoration: const InputDecoration(
                labelText: 'Capacite Espace',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la capacite';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: prixController,
              decoration: const InputDecoration(
                labelText: 'Prix Espace',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le prix';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: adresseController,
              decoration: const InputDecoration(
                labelText: 'Adresse Espace',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer adresse';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50), // Bouton plus grand
              ),
              onPressed: isLoading ? null : () async { // Désactive le bouton pendant le chargement
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true; // Début du chargement
                  });

                  final espace = Espace(
                    idEspace: widget.espace != null ? widget.espace!.idEspace : null,
                    nomEspace: nomController.text,
                    descriptionEspace: descriptionController.text,
                    capacite: int.parse(capaciteController.text),
                    prixEspace: int.parse(prixController.text),
                    adresseEspace: adresseController.text,
                    imageEspace: widget.espace != null ? widget.espace!.imageEspace : null,
                  );

                  final byte = await image?.readAsBytes();

                  Map<String, http.MultipartFile> images = {};
                  if (image != null) {
                    images = {
                      'image': http.MultipartFile.fromBytes('image', byte!, filename: image!.name)
                    };
                  }

                  var resultat = await Api().saveEspace(
                    espace,
                    images: images,
                  );

                  if (resultat['saved']) {
                    Navigator.pop(context);
                    widget.onSuccess();
                  } 
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Erreur lors de l\'enregistrement: ${resultat['message_error']}'),
                    ));
                  }

                  setState(() {
                    isLoading = false; // Fin du chargement
                  });
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white) // Loader pendant le chargement
                  : const Text('Enregistrer'), // Texte mis à jour
            ),
          ],
        ),
      ),
      ),
    );
  }
}

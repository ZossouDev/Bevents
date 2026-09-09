import 'dart:io';

import 'package:bevent/models/evenement.dart';
import 'package:bevent/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EvenementFormulairePage extends StatefulWidget {
  final int? id;
  final Evenement? evenement;
  final void Function() onSuccess;
  const EvenementFormulairePage({super.key, this.id, this.evenement, required this.onSuccess});

  @override
  State<EvenementFormulairePage> createState() => _EvenementFormulairePageState();
}

class _EvenementFormulairePageState extends State<EvenementFormulairePage> {

//Liste des catégories
  List<DropdownMenuItem> categoryList = [
    const DropdownMenuItem(
      value: 'Appearance/Singing',
      child: Text(
        'Apparition/Chant',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Attaraction',
      child: Text(
        'Rencontre',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Camp, Trip or Retreat',
      child: Text(
        'Camp, voyage ou retraite',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Class, Training, or Workshop',
      child: Text(
        'Cours, formation ou atelier',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Concert/Performance',
      child: Text(
        'Concert/Performance',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Conference',
      child: Text(
        'Conference',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Convention',
      child: Text(
        'Convention',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Dinner or Gala',
      child: Text(
        'Dinner ou Gala',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Festival or Fair',
      child: Text(
        'Festival ou foire',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Game or Competition',
      child: Text(
        'Jeu ou Competition',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Meeting/Networking event',
      child: Text(
        'Meeting/Réseautage',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Party/Social Gathering',
      child: Text(
        'Fête/rassemblement social',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Other',
      child: Text(
        'Autres',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
  ];

//Liste des types
  List<DropdownMenuItem> typeList = [
    const DropdownMenuItem(
      value: 'Public',
      child: Text(
        'Public',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Privé',
      child: Text(
        'Privé',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    ),
  ];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController categorieController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController placesController = TextEditingController();
  TextEditingController prixControler = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController idOrgaController = TextEditingController();
  
  late DateTime? dateTime = null;

  bool isGratuit = false;
  String selectedCategorie = 'Public';
  XFile? image;

  ImagePicker picker = ImagePicker();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    if (widget.evenement != null) {
      nomController.text = widget.evenement!.nomEvent!;
      typeController.text = widget.evenement!.typeEvent!;
      categorieController.text = widget.evenement!.categorie!;
       lieuController.text = widget.evenement!.lieu!;
        descriptionController.text = widget.evenement!.descriptionEvent!;
         placesController.text = widget.evenement!.nbrePlaces!.toString();
          dateTimeController.text = widget.evenement!.horaireDebut!;
      prixControler.text = widget.evenement!.prix!;
      idOrgaController.text =  widget.evenement!.idOrga!.toString();
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
                labelText: 'Nom Evenement',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event_note_sharp),
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
              controller: lieuController,
              decoration: const InputDecoration(
                labelText: 'Lieu Evenement',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
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
              onTap: () => _selectDate(context),
              controller: dateTimeController,
              decoration: const InputDecoration(
                labelText: 'Horaire Evenement',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
                        items: categoryList,
                        validator: (value) => selectedCategorie == null
                            ? 'Selectionner une categorie'
                            : null,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                          labelText: 'Categorie',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              width: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedCategorie = value;
                          });
                        },
                      ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
                              items: typeList,
                              validator: (value) => typeController.text.isEmpty
                                  ? 'Selectionner un type'
                                  : null,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                                labelText: 'Type',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    width: 1.5,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  typeController.text = value;
                                });
                              },
                            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 2,
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description Evenement',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Checkbox(
                            value: isGratuit,
                            onChanged: (value) {
                              setState(() {
                                isGratuit = value!;
                                if (isGratuit) {
                                  prixControler.text = '';
                                }
                              });
                            },
                          ),
                          const Text('Gratuit'),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: _buildInputDecorator(
                              labelText: 'Prix',
                              controller: prixControler,
                              enabled: !isGratuit,  
                              keyboardType: TextInputType.number, // Spécifier le type de clavier                            
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
            TextFormField(
              controller: placesController,
              decoration: const InputDecoration(
                labelText: 'Nombres de Places',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_num_outlined),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50), // Bouton plus grand
              ),
              onPressed: isLoading ? null : () async { // Désactive le bouton pendant le chargement
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true; // Début du chargement
                  });


                  String prixValue = isGratuit ? 'Gratuit' : prixControler.text;
                  final evenement = Evenement(                   
                    idEvent: widget.evenement != null ? widget.evenement!.idEvent : null,
                    nomEvent: nomController.text,
                    lieu: lieuController.text,
                    typeEvent: typeController.text,
                    categorie: categorieController.text,
                    horaireDebut: dateTimeController.text,
                    descriptionEvent: descriptionController.text,
                    nbrePlaces: int.parse(placesController.text),
                    prix: prixValue,
                    imageEvent: widget.evenement != null ? widget.evenement!.imageEvent : null,
                    idOrga: widget.id,
                  );

                  final byte = await image?.readAsBytes();

                  Map<String, http.MultipartFile> images = {};
                  if (image != null) {
                    images = {
                      'image': http.MultipartFile.fromBytes('image', byte!, filename: image!.name)
                    };
                  }

                  var resultat = await Api().saveEvenement(
                    evenement,
                    images: images,
                  );

                  if (resultat['saved']) {
                    Navigator.pop(context);
                    widget.onSuccess();
                  } else {
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

String? validatePrice(String value) {
  if (!isGratuit && value.isEmpty) {
    return 'Veuillez entrer un prix ou cocher Gratuit';
  }
  if (!isGratuit && int.tryParse(value) == null) {
    return 'Le prix doit être un nombre';
  }
  return null;
}

Widget _buildInputDecorator({
  required String labelText,
  required TextEditingController controller,
  bool enabled = true,
  TextInputType? keyboardType, // Ajout de cette propriété
}) {
  return InputDecorator(
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          width: 1.5,
        ),
      ),
    ),
    child: SizedBox(
      height: 40.0,
      width: 250.0,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType, // Utilisation du type de clavier spécifié
      ),
    ),
  );
}
    Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        locale: LocaleType.fr,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(new Duration(days: 365)));
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
        dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime!);
      });
    }
  }
}

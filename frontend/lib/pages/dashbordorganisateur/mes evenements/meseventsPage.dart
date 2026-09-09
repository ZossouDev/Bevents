import 'package:bevent/models/evenement.dart';
import 'package:bevent/pages/dashbordorganisateur/mes%20evenements/eventsFormulaire.dart';
import 'package:bevent/services/api.dart';
import 'package:bevent/services/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart'; // Package to send emails

class MesEvenement extends StatefulWidget {
  final int? id;

  const MesEvenement({super.key, this.id});

  @override
  State<MesEvenement> createState() => _MesEvenementState();
}

class _MesEvenementState extends State<MesEvenement> {
  List<Evenement> evenement = [];
  List<Evenement> evenementFiltres = [];
  bool chargement = false;
  bool delete = false;

  @override
  void initState() {
    super.initState();
    obtenirListeEvenement(widget.id!);
  }

  void obtenirListeEvenement(int id) async {
    setState(() {
      chargement = true;
    });
    print("Fetching events...");
    final data = await Api().getEvenement(idOrga: id.toString());
    print("Events fetched: ${data.length}");
    if (data.isNotEmpty) {
      setState(() {
        evenement = data;
        evenementFiltres = data;
        chargement = false;
      });
    } else {
      setState(() {
        chargement = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 171, 169),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              color : Color.fromARGB(255, 11, 1, 56),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "MES EVENEMENTS",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () => obtenirListeEvenement(widget.id!),
                      tooltip: "Rafraîchir la liste",
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Creer un evenement",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: EvenementFormulairePage(
                             id : widget.id,
                              onSuccess: () {                           
                                obtenirListeEvenement(widget.id!); // Update to refresh event list
                              },
                              
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: chargement
                    ? const Center(child: CircularProgressIndicator())
                    : evenementFiltres.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('N°')),
                                  DataColumn(label: Text('Affiche')),
                                  DataColumn(label: Text('Nom')),
                                  DataColumn(label: Text('Type')),
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Statut')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: List<DataRow>.generate(
                                  evenementFiltres.length,
                                  (index) {
                                    final stag = evenementFiltres[index];
                                    return DataRow(
                                      cells: [
                                        DataCell(Text((index + 1).toString())),
                                        DataCell(
                                          stag.imageEvent != null
                                              ? Container(
                                                  width: 50, // Largeur de l'image
                                                  height: 50, // Hauteur de l'image
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10), // Bordure arrondie
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10), // Bordure arrondie
                                                    child: Image.network(
                                                      Urls.assetUrl(stag.imageEvent!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(), 
                                          //Icon(Icons.image_not_supported),
                                        ),
                                        DataCell(Text(stag.nomEvent ?? '')),
                                        DataCell(Text(stag.typeEvent ?? '')),
                                        DataCell(Text(stag.horaireDebut ?? '')),
                                        DataCell(
                                          Text(
                                            stag.statut ?? '',
                                            style: TextStyle(
                                              color: stag.statut == "Valider"
                                                  ? Color.fromARGB(255, 11, 1, 56)
                                                  : stag.statut == "En attente"
                                                      ? Colors.orange
                                                      : stag.statut == "Rejeter"
                                                          ? Color.fromARGB(255, 175, 15, 3)
                                                          : Colors.black,
                                            ),
                                          ),
                                        ),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 11, 1, 56)),
                                              onPressed: () {
                                                print('id: ${stag.idEvent}');
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  content: EvenementFormulairePage(
                                                    evenement: stag,
                                                    id: widget.id,
                                                    onSuccess: () {
                                                      obtenirListeEvenement(widget.id!);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            ),
                                            const SizedBox(width: 8),
                                          //   IconButton(
                                          //   icon: delete && stag==evenementFiltres.firstWhere((element) => element==stag)
                                          //       ? const CircularProgressIndicator()
                                          //       : const Icon(Icons.delete, color: Color.fromARGB(255, 175, 15, 3)),
                                          //   onPressed: () async {
                                          //     final bool confirmDelete = await showDialog(
                                          //       context: context,
                                          //       builder: (BuildContext dialogContext) {
                                          //         return AlertDialog(
                                          //           title: const Text('Confirmer la suppression'),
                                          //           content: const Text(
                                          //               'Êtes-vous sûr de vouloir supprimer cet evnement?'),
                                          //           actions: <Widget>[
                                          //             TextButton(
                                          //               onPressed: () =>
                                          //                   Navigator.of(dialogContext).pop(false),
                                          //               child: const Text('Annuler'),
                                          //             ),
                                          //             TextButton(
                                          //               onPressed: () =>
                                          //                   Navigator.of(dialogContext).pop(true),
                                          //               child: const Text('Supprimer'),
                                          //             ),
                                          //           ],
                                          //         );
                                          //       },
                                          //     );

                                          //     if (confirmDelete) {
                                          //       setState(() {
                                          //         delete = true;
                                          //       });
                                          //       final reponse =
                                          //           await Api().deleteEvenement(stag.idEvent.toString() as int);
                                          //       if (reponse['deleted']) {
                                          //         obtenirListeEvenement(widget.id!);
                                          //       } else {
                                          //         ScaffoldMessenger.of(context).showSnackBar(
                                          //           SnackBar(
                                          //             content: Text(reponse['message_error'] ??
                                          //                 "Erreur lors de la suppression de l'evenemnt."),
                                          //             backgroundColor: Color.fromARGB(255, 175, 15, 3),
                                          //           ),
                                          //         );
                                          //       }
                                          //       setState(() {
                                          //         delete = false;
                                          //       });
                                          //     }
                                          //   },
                                          // ),
                                          ],
                                        )),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : Container(
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 48.0, color: Colors.grey),
                                  Text(
                                    "Aucun evenement trouvé",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:bevent/models/evenement.dart';
import 'package:bevent/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart'; // Package to send emails

class EvenementListPage extends StatefulWidget {
  const EvenementListPage({super.key});

  @override
  State<EvenementListPage> createState() => _EvenementListPageState();
}

class _EvenementListPageState extends State<EvenementListPage> {
  final List<String> status = ["Tous", "En attente", "Valider"];
  List<Evenement> evenement = [];
  List<Evenement> evenementFiltres = [];
  bool chargement = false;
  bool delete = false;
  String? selectedStatus;

  @override
  void initState() {
    selectedStatus = status.first;
    super.initState();
    obtenirListeEvenement();
  }

  void obtenirListeEvenement() async {
    setState(() {
      chargement = true;
    });
    print("Fetching events...");
    final data = await Api().getEvenement();
    print("Events fetched: ${data.length}");
    if (data.isNotEmpty) {
      setState(() {
        evenement = data;
        filtreEvenement();
        chargement = false;
      });
    } else {
      setState(() {
        chargement = false;
      });
    }
  }

  void filtreEvenement() {
    setState(() {
      if (selectedStatus == "Tous") {
        evenementFiltres = evenement;
      } else {
        evenementFiltres = evenement.where((event) => event.statut == selectedStatus).toList();
      }
    });
  }

  void showConfirmationDialog(Evenement event, String newStatut) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment $newStatut cet événement?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                updateEvenementStatut(event, newStatut); // Met à jour le statut
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void updateEvenementStatut(Evenement event, String newStatut) async {
    // Update local status
    setState(() {
      event.statut = newStatut;
      filtreEvenement();
    });

    // Logic to send email to the event organizer
    final Email email = Email(
      body: 'Votre événement "${event.nomEvent}" a été ${newStatut.toLowerCase()}.',
      subject: 'Mise à jour du statut de votre événement',
      recipients: ['organisateur@example.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);

    // Optionally, update the event status in the local list
    // Here we assume that the event is updated locally without backend call
    setState(() {
      evenement = evenement.map((e) {
        if (e.idEvent == event.idEvent) {
          e.statut = newStatut;
        }
        return e;
      }).toList();
      filtreEvenement();
    });
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
              color: Color.fromARGB(255, 11, 1, 56),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "LISTES DES EVENEMENTS",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: obtenirListeEvenement,
                      tooltip: "Rafraîchir la liste",
                    ),
                    const SizedBox(width: 12.0),
                    DropdownButton<String>(
                      value: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                          filtreEvenement();
                        });
                      },
                      items: status.map<DropdownMenuItem<String>>((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status, selectionColor: Colors.white),
                        );
                      }).toList(),
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
                                              : SizedBox(), // Afficher un widget vide si stag.imageEvent est null
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
                                                          ? const Color.fromARGB(255, 158, 16, 6)
                                                          : Colors.black,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          stag.statut == "En attente"
                                              ? Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showConfirmationDialog(stag, "Valider");
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromARGB(255, 11, 1, 56),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      ),
                                                      child: const Text(
                                                        'Valider',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showConfirmationDialog(stag, "Rejeter");
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromARGB(255, 179, 16, 4),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      ),
                                                      child: const Text(
                                                        'Rejeter',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),
                                        ),
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

import 'package:bevent/models/espace.dart';
import 'package:bevent/services/api.dart';
import 'package:bevent/services/urls.dart';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';

class EspacePage extends StatefulWidget {
  const EspacePage({super.key});

  @override
  State<EspacePage> createState() => _EspacePageState();
}

class _EspacePageState extends State<EspacePage> {
  List<String> status = ["en attente", "Valider"];
  List<Espace> espace = [];
  List<Espace> espaceFiltres = [];

  bool loading = false;
  bool chargement = false;

  String? selectedStatus;

  void getListEspace() async {
    setState(() {
      loading = true;
      chargement = true;
    });
    final data = await Api().getEspace();
    print('Espaces récupérés : $data');

    if (data.isNotEmpty) {
      setState(() {
        espace = data;
        espaceFiltres = data; // Mise à jour des filtres également
        chargement = false;
        loading = false;
      });
    } else {
      setState(() {
        chargement = false;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    selectedStatus = status.first;
    getListEspace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 171, 169),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              color : Color.fromARGB(255, 11, 1, 56),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text(
                          "CATALOGUE D'ESPACES DISPONIBLES",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: getListEspace,
                      tooltip: "Rafraîchir la liste",
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                color : Color.fromARGB(255, 172, 171, 169),
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : espace.isNotEmpty
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 420,
                            ),
                            itemCount: espace.length,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        Urls.assetUrl(espace[index].imageEspace ?? ''),
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${espace[index].nomEspace}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                           Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${espace[index].descriptionEspace}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Peut contenir : ${espace[index].capacite} et coûte ${espace[index].prixEspace}",
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${espace[index].disponibilite}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(255, 11, 1, 56),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              //_showRentForm(context, espace[index]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                              ),
                                            child: Text("Louer Espace",
                                            style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color : Colors.white,
                                          ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 48.0, color: Colors.grey),
                                  Text(
                                    "Aucun espace trouvé",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black54),
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
  void _showRentForm(BuildContext context, Espace espace) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Louer ${espace.nomEspace}"),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nom du locataire',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email du locataire',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Date de location',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Confirmer"),
              onPressed: () {
                // Ajoutez ici la logique de traitement du formulaire de location.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

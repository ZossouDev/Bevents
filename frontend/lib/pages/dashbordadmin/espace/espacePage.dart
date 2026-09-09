import 'package:bevent/models/espace.dart';
import 'package:bevent/pages/dashbordadmin/espace/espaceFormulaire.dart';
import 'package:bevent/services/api.dart';
import 'package:bevent/services/urls.dart';
import 'package:flutter/material.dart';

class EspaceListPage extends StatefulWidget {
  const EspaceListPage({super.key});

  @override
  State<EspaceListPage> createState() => _EspaceListPageState();
}

class _EspaceListPageState extends State<EspaceListPage> {
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
                          "LISTE DES ESPACES",
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
                      icon: const Icon(Icons.refresh, color : Colors.white),
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
                                        Urls.assetUrl(espace[index].imageEspace!),
                                        fit: BoxFit.cover,
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
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Elle est située à : ${espace[index].adresseEspace}",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    // fontStyle: FontStyle.italic,
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
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(255, 11, 1, 56),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Center(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 11, 1, 56),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: EspaceFormulairePage(
                onSuccess: () {
                  setState(() {
                    getListEspace();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

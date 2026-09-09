import 'package:bevent/models/organisateur.dart';
import 'package:bevent/services/api.dart';
import 'package:flutter/material.dart';
import 'orgaFormulaire.dart';
import 'package:bevent/constants/constants.dart';

class OrganisateurListPage extends StatefulWidget {
  const OrganisateurListPage({super.key});

  @override
  State<OrganisateurListPage> createState() => _OrganisateurListPageState();
}

class _OrganisateurListPageState extends State<OrganisateurListPage> {
  final List<String> genre = ["Tous", "Masculin", "Féminin", "Autres"];

  List<Organisateur> organisateur = [];
  List<Organisateur> organisateurFiltres = [];

  bool chargement = false;
  bool delete = false;
  bool menuOuvert = false;

  @override
  void initState() {
    super.initState();
    obtenirListeOrganisateur();
  }

  void obtenirListeOrganisateur() async {
    setState(() {
      chargement = true;
    });
    final data = await Api().getOrganisateur();
    if (data.isNotEmpty) {
      setState(() {
        organisateur = data;
        organisateurFiltres = data; // Mise à jour des filtres également
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
                    Expanded(
                      child: Container(
                        child: const Text(
                          "LISTES DES ORGANISATEURS",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color : Colors.white),
                      onPressed: obtenirListeOrganisateur,
                      tooltip: "Rafraîchir la liste",
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              "Ajouter un organisateur",
                              style: TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: OrganisateurFormulairePage(
                                    onSuccess: () {
                                      obtenirListeOrganisateur();
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
                    Expanded(
                      child: chargement
                          ? Center(child: CircularProgressIndicator())
                          : organisateurFiltres.isNotEmpty
                              ? ListView.builder(
                                  itemCount: organisateurFiltres.length,
                                  itemBuilder: (context, index) {
                                    final stag = organisateurFiltres[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      title: Text("${stag.nomOrga!} ${stag.prenomOrga!}"),
                                      subtitle: Text(stag.emailOrga!),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  content: OrganisateurFormulairePage(
                                                    organisateur: stag,
                                                    onSuccess: () {
                                                      obtenirListeOrganisateur();
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          // IconButton(
                                          //   icon: delete && stag==organisateurFiltres.firstWhere((element) => element==stag)
                                          //       ? const CircularProgressIndicator()
                                          //       : const Icon(Icons.delete, color: Colors.red),
                                          //   onPressed: () async {
                                          //     final bool confirmDelete = await showDialog(
                                          //       context: context,
                                          //       builder: (BuildContext dialogContext) {
                                          //         return AlertDialog(
                                          //           title: const Text('Confirmer la suppression'),
                                          //           content: const Text(
                                          //               'Êtes-vous sûr de vouloir supprimer cet organisateur?'),
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
                                          //           await Api().deleteOrganisateur(stag.idOrga.toString());
                                          //       if (reponse['deleted']) {
                                          //         obtenirListeOrganisateur();
                                          //       } else {
                                          //         ScaffoldMessenger.of(context).showSnackBar(
                                          //           SnackBar(
                                          //             content: Text(reponse['message_error'] ??
                                          //                 "Erreur lors de la suppression de l'organisateur."),
                                          //             backgroundColor: Colors.red,
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
                                          "Aucun organisateur trouvé",
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


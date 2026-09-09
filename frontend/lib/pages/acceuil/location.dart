import 'package:bevent/pages/acceuil/connexion.dart';
import 'package:bevent/pages/acceuil/contact.dart';
import 'package:bevent/pages/acceuil/evenement.dart';
import 'package:bevent/pages/acceuil/home.dart';
import 'package:bevent/pages/acceuil/location_detail.dart';
import 'package:flutter/material.dart';
import 'package:bevent/models/espace.dart';
import 'package:bevent/services/api.dart';
import 'package:bevent/services/urls.dart';
import 'package:intl/intl.dart'; // Importez le package intl pour le formatage des nombres
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart'; // Importez le SDK Kkiapay

class location extends StatefulWidget {
  @override
  _locationState createState() => _locationState();
}

class _locationState extends State<location> {
  List<Espace> espaces = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getListEspace();
  }

  void getListEspace() async {
    setState(() {
      loading = true;
    });
    final data = await Api().getEspace();
    print('Espaces récupérés : $data');

    setState(() {
      espaces = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat("#,##0", "fr_FR"); // Format personnalisé
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Color.fromARGB(255, 11, 1, 56),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 50,
                          width: 150,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/zyro.png"),
                                  fit:BoxFit.cover)
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => home()),
                                );
                              },
                              child: const Text('Acceuil', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => event()),
                                );
                              },
                              child: const Text('Évènements', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => location()),
                                );
                              },
                              child: const Text('Locations', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => contact()),
                                );
                              },
                              child: const Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => connect()),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.person_add_alt_1_rounded, color: Colors.orange, size: 30.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/org2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 80.0, color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(text: "LOUER", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                              TextSpan(text: "\nLouer des espaces ici en quelques minutes chrono !", style: TextStyle(fontSize: 30.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Liste défilante des espaces
            loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (espaces.length / 3).ceil(), // Utilisez la division entière pour déterminer le nombre de lignes nécessaires
                    itemBuilder: (context, rowIndex) {
                      return Row(
                        children: List.generate(3, (colIndex) {
                          final index = rowIndex * 3 + colIndex; // Calculez l'index de l'espace dans la liste
                          if (index < espaces.length) {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationDetail(location: espaces[index]),
                                    ),
                                  );
                                },
                                child: Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        Urls.assetUrl(espaces[index].imageEspace ?? ''),
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${espaces[index].nomEspace}",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.people, color: Colors.orange),
                                            SizedBox(width: 5),
                                            Text(
                                              "${espaces[index].capacite}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.location_on, color: Colors.orange),
                                            SizedBox(width: 5),
                                            Text(
                                              "${espaces[index].adresseEspace}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.monetization_on_outlined, color: Colors.orange),
                                            SizedBox(width: 5),
                                            Text(
                                              "${formatCurrency.format(espaces[index].prixEspace)} FCFA",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Container(), // Un conteneur vide pour les cellules supplémentaires si le nombre d'espaces n'est pas un multiple de 3
                            );
                          }
                        }),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

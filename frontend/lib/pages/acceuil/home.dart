import 'package:bevent/pages/acceuil/connexion.dart';
import 'package:bevent/pages/acceuil/contact.dart';
import 'package:bevent/pages/acceuil/evenement.dart';
import 'package:bevent/pages/acceuil/location.dart';
import 'package:bevent/pages/acceuil/recherche.dart';
import 'package:flutter/material.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                        ),
                        Row(
                          children: [
                            TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  home()),
                                      );
                                  },
                                  child: const Text('Acceuil', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  event()),
                                      );
                                  },
                                  child: const Text('Évènements', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  location()),
                                      );
                                  },
                                  child: const Text('Locations', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  contact()),
                                      );
                                  },
                                  child: const Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                          ],
                        ),
                            
                        Row(
                          children: [
                            // TextButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => search()),
                            //       );
                            //   },
                            //   child: const Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Icon(Icons.search_outlined, color: Colors.orange, size: 30.0),
                            //     ],
                            //   ),
                            // ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  connect()),
                                  );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                //  Text('Connexion', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                    height: 700,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/introbg1.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 70.0, color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(text: 'La solution idéale', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                              TextSpan(text: ', pour \névènementiel'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(100.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Rechercher événement...',
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.search, color: Colors.orange, size: 30.0),
                                  onPressed: () {
                                    // Ajouter le code de recherche ici
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



  // Helper method to build navigation item
  Widget _buildNavItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 3, 255, 15),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

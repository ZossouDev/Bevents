import 'package:flutter/material.dart';
import 'package:bevent/models/evenement.dart';
import 'package:bevent/pages/acceuil/connexion.dart';
import 'package:bevent/pages/acceuil/contact.dart';
import 'package:bevent/pages/acceuil/event_detail.dart';
import 'package:bevent/pages/acceuil/home.dart';
import 'package:bevent/pages/acceuil/location.dart';
import 'package:bevent/services/api.dart';
import 'package:bevent/services/urls.dart';
import 'package:intl/intl.dart';

class event extends StatefulWidget {
  @override
  _eventState createState() => _eventState();
}

class _eventState extends State<event> {
  List<Evenement> evenements = [];
  bool loading = false;
  int? hoveredIndex;

  @override
  void initState() {
    super.initState();
    getEvenements();
  }

  void getEvenements() async {
    setState(() {
      loading = true;
    });

    final data = await Api().getEvenement();

    setState(() {
      evenements = data;
      loading = false;
    });
  }

  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateStr; // Retourner la chaîne d'origine si la conversion échoue
    }
  }

  String formatTime(String timeStr) {
    try {
      DateTime time = DateTime.parse(timeStr);
      return DateFormat('HH:mm:ss').format(time);
    } catch (e) {
      return timeStr; // Retourner la chaîne d'origine si la conversion échoue
    }
  }

  String formatLocation(String location) {
    // Exemple de formatage du lieu : Ajoutez ici le formatage souhaité
    return "$location, Benin"; // Ajoutez le pays selon vos besoins
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat("#,##0", "fr_FR");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 171, 169),
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
                              fit: BoxFit.cover,
                            ),
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
                        image: AssetImage("images/event.jpg"),
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
                              TextSpan(text: "EVENEMENT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                              TextSpan(text: '\nDécouvrez ici les évènements du moment !', style: TextStyle(fontSize: 30.0)),
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
            loading
                ? Center(child: CircularProgressIndicator())
               : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (evenements.length / 3).ceil(),
                    itemBuilder: (context, rowIndex) {
                      return Row(
                        children: List.generate(3, (colIndex) {
                          final index = rowIndex * 3 + colIndex;
                          if (index < evenements.length) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 172, 171, 169),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      if (hoveredIndex == index)
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            hoveredIndex = index;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            hoveredIndex = null;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          transform: hoveredIndex == index ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EventDetail(evenement: evenements[index]),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              clipBehavior: Clip.hardEdge,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    Urls.assetUrl(evenements[index].imageEvent ?? ''),
                                                    fit: BoxFit.cover,
                                                    height: 200,
                                                    width: double.infinity,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "${evenements[index].nomEvent}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.category, color: Colors.orange),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "${evenements[index].typeEvent}",
                                                          style: TextStyle(fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.calendar_month_outlined, color: Colors.orange),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "${formatDate(evenements[index].horaireDebut!)} à ${formatTime(evenements[index].horaireDebut!)}",
                                                          style: TextStyle(fontSize: 20),
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
                                                          "${formatLocation(evenements[index].lieu!)}", // Utilisez la méthode de formatage pour le lieu
                                                          style: TextStyle(fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        SizedBox(width: 5),
                                                        Text(
                                                          evenements[index].prix == 'Gratuit'
                                                            ? "Gratuit"
                                                            : "${formatCurrency.format(double.parse(evenements[index].prix!))} FCFA",
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
                                                        ),
                                                      ],
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
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Container(),
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

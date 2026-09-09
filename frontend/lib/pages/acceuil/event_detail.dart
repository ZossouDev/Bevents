import 'package:flutter/material.dart';
import 'package:bevent/models/evenement.dart';
import 'package:bevent/services/urls.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart'; // Importer le package intl pour le formatage de date et heure

class EventDetail extends StatelessWidget {
  final Evenement evenement;

  EventDetail({required this.evenement});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails évènement", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 500.0, // Augmenter la hauteur du conteneur pour agrandir l'image
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                ),
                items: [evenement.imageEvent].map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                        child: Image.network(
                          Urls.assetUrl(item),
                          fit: BoxFit.cover, // Utiliser BoxFit.cover pour agrandir l'image
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    "${evenement.nomEvent}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Type évenement:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    "${evenement.typeEvent}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Catégorie évenement:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    "${evenement.categorie}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Date, heure et lieu de l'évènement:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.orange),
                      SizedBox(width: 5.0),
                      Text(
                        "${formatDate(evenement.horaireDebut!)}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 55.0),
                      Icon(Icons.access_time, color: Colors.orange),
                      SizedBox(width: 5.0),
                      Text(
                        "${formatTime(evenement.horaireDebut!)}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.orange),
                      SizedBox(width: 5.0),
                      Text(
                        "${evenement.lieu}, Benin",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Résumé de l'evenement:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    "${evenement.descriptionEvent}",
                    style: TextStyle(fontSize: 20),
                  ),
                  //Spacer(),
                  SizedBox(height: 30.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your action for buying tickets here
                      },
                      child: Text('Acheter billet'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: Colors.orange,
                      ),
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

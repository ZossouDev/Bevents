import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bevent/models/espace.dart';
import 'package:bevent/services/urls.dart';
import 'package:intl/intl.dart'; // Importez le package intl pour le formatage des nombres

class LocationDetail extends StatelessWidget {
  final Espace location;

  LocationDetail({required this.location});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat("#,##0", "fr_FR"); // Format personnalisé
    return Scaffold(
      appBar: AppBar(
        title: Text("Details de l'Espace", style : TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 2.0,
                ),
                items: [location.imageEspace].map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                        ),
                        child: Image.network(
                          Urls.assetUrl(item),
                          fit: BoxFit.cover,
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
                    "${location.nomEspace}",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(height: 16.0),
                  Text(
                    "Capacité:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "${location.capacite}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Adresse:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                   "${location.adresseEspace}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
      
                  SizedBox(height: 16.0),
                  Text(
                    "Prix:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                   "${formatCurrency.format(location.prixEspace)} FCFA",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Description:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "${location.descriptionEspace}",
                    style: TextStyle(fontSize: 16),
                  ),
                  //Spacer(),
                  SizedBox(height: 30.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your action for booking the location here
                      },
                      child: Text('Louer salle'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: Colors.green,
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

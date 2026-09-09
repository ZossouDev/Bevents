import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bevent/services/urls.dart';
import 'dart:convert';

class dashboardadmin extends StatefulWidget {
  const dashboardadmin({Key? key}) : super(key: key);

  @override
  State<dashboardadmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<dashboardadmin> {
  bool hasOpenProfileMenu = false;
  int numberOfOrganizers = 0; // Variable pour stocker le nombre d'organisateurs

  @override
  void initState() {
    super.initState();
    fetchNumberOfOrganizers(); // Appel à la méthode pour récupérer le nombre d'organisateurs
  }

  Future<void> fetchNumberOfOrganizers() async {
    try {
      final response = await http.get(Urls.apiUri('countorga.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          numberOfOrganizers = data['total']; // Mettre à jour le nombre d'organisateurs
        });
      } else {
        throw Exception('Failed to load organizer count');
      }
    } catch (e) {
      print('Error fetching organizer count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 172, 171, 169),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Wrap(
                    runAlignment: WrapAlignment.spaceAround,
                    spacing: 20.0,
                    children: <Widget>[
                      _buildCard(Icons.group, "Nombre d'organisateurs", numberOfOrganizers.toString(), Colors.orange),
                      _buildCard(Icons.check_circle, "Nombre d'évènements validés", "5", Colors.orange),
                      _buildCard(Icons.timer, "Nombre d'évènements en attente", "1", Colors.orange),
                      Row(
                        children: [
                          _buildCard(Icons.business, "Nombre total d'espaces", "6", Colors.orange),
                          SizedBox(width: 20),
                          _buildCard(Icons.highlight_remove_outlined, "Nombre d'espaces occupées", "0", Colors.orange),
                          SizedBox(width: 20),
                          _buildCard(Icons.store, "Nombre d'espaces disponibles", "6", Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // IconButton(
                      // color: Color.fromARGB(255, 12, 6, 43),
                      //   onPressed: () {
                      //     setState(() {
                      //       hasOpenProfileMenu = !hasOpenProfileMenu;
                      //     });
                      //   },
                      //   // icon: Icon(
                      //   //   //hasOpenProfileMenu ? Icons.arrow_right : Icons.account_circle_rounded,
                      //   // ),
                      // ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String value, Color color) {
    return Container(
      height: 250,
      width: 350,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Icon(
                icon,
                size: 40.0,
                color: color,
              ),
              backgroundColor: Color.fromARGB(255, 12, 6, 43),
              radius: 40,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

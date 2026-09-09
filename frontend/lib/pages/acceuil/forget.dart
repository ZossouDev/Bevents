import 'package:flutter/material.dart';

class forget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 800,
              width: double.infinity,
              decoration: const BoxDecoration(
               color: Color.fromARGB(255, 10, 50, 80),
               /* image: DecorationImage(
                  image: AssetImage("images/3.jpg"),
                  fit: BoxFit.cover,
                ),*/
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/zyro.png"),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 500,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text('VOTRE EMAIL DE CONNEXION',
                                      style: TextStyle(fontSize:15, color: Colors.black, fontWeight: FontWeight.bold),),
                              ),
                            SizedBox(height: 10),
                            const TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: 
                                ElevatedButton(
                                  onPressed: () {
                                    // Ajouter la logique pour le bouton de connexion
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange, // Couleur du fond du bouton
                                  ),
                                  child: Text('VALIDER', style: TextStyle(fontSize:20, color: Colors.white),),
                                ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
import 'package:bevent/pages/acceuil/connexion.dart';
import 'package:bevent/pages/acceuil/evenement.dart';
import 'package:bevent/pages/acceuil/home.dart';
import 'package:bevent/pages/acceuil/location.dart';
import 'package:bevent/pages/acceuil/recherche.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class contact extends StatelessWidget {
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
                    color: const Color.fromARGB(255, 11, 1, 56),
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
                            children: [
                              //  Text('BEvent', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                              //   Icon(Icons.event_note, color: Colors.orange, size: 30.0),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  home()),
                                );
                              },
                              child: Ink(
                                color: Colors.red,
                                child: Text('Acceuil', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
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
                            //       MaterialPageRoute(builder: (context) =>  search()),
                            //     );
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
                                 // Text('Connexion', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                          image: AssetImage("assets/images/aboutbg.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                                style: TextStyle(fontSize: 60.0, color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "POUR NOUS CONTACTER",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.orange),
                                  )
                                ]),
                          )
                        ],
                      )),
                  SizedBox(height: 100.0),
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.orange, size: 70.0),
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Siège à Cotonou",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        VerticalDivider(width: 200, color: Colors.black,),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.mark_email_read, color: Colors.orange, size: 70.0),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                  /*  TextSpan(
                                      text: "Email : ",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                    ),*/
                                    TextSpan(
                                      text: "Email: bevent@gmail.com",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('mailto:bevent@gmail.com');
                                        },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        VerticalDivider(width: 200, color: Colors.black,),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.call, color: Colors.orange, size: 70.0),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                   /* TextSpan(
                                      text: "Tel: ",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,),
                                    ),*/
                                    TextSpan(
                                      text: "Tel: +229 00 00 00 00",
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('tel:+22900000000');
                                        },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
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

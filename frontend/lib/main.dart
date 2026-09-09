import 'package:bevent/pages/acceuil/connexion.dart';
import 'package:bevent/pages/acceuil/home.dart';
import 'package:bevent/pages/home_page.dart';
import 'package:bevent/pages/home_page2.dart';
import 'package:bevent/pages/acceuil/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BEvent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:home(),
    );
  }
}


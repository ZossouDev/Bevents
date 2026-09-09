import 'package:flutter/material.dart';

class search extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchQueryController = TextEditingController();

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQueryController.clear();
    });
  }

  void _handleSearch() {
    // Implement your search logic here
    print('Searching for: ${_searchQueryController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchQueryController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
              )
            : Text('Home Page'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _startSearch,
            ),
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: _stopSearch,
            ),
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _handleSearch,
            ),
          if (!_isSearching)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Center(
        child: Text('Content goes here'),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login or Register'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement login functionality
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to registration page
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
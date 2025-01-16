import 'package:flutter/material.dart';
import 'Lihat_0046.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageNavBarMenu extends StatefulWidget {
  @override
  _PageNavBarMenuState createState() => _PageNavBarMenuState();
}

class _PageNavBarMenuState extends State<PageNavBarMenu> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Nav Bar'),
        backgroundColor: Colors.brown,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Welcome'),
            ),
            Divider(),
            ListTile(
              title: Text('Expense Tracker'),
              trailing: Icon(Icons.money),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/lihat');
              },
            ),
            ListTile(
              title: Text('Kontak'),
              trailing: Icon(Icons.phone),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/kontak');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
          child: Text('Home Page',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0))),
    );
  }
}

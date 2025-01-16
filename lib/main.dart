import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'Input_0046.dart';
import 'Lihat_0046.dart';
import 'hapus_0046.dart';
// import 'edit_0046.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      ),
      home: Lihat_0046(),
      routes: <String, WidgetBuilder>{
        '/input': (BuildContext context) => Input_0046(),
        '/lihat': (BuildContext context) => Lihat_0046(),
        '/hapus': (BuildContext context) => Hapus_0046(),
        // '/edit': (BuildContext context) => Edit_0046(),
      }));
}

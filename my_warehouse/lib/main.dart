import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Color.dart';
import 'package:my_warehouse/screens/NavigationMenu.dart';

final Color laranja = HexColor.fromHex("#CA5C2F");

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Warehouse',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavigationMenu(),
    );
  }
}

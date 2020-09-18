import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_warehouse/functions/Color.dart';
import 'package:my_warehouse/screens/Cozinhar.dart';
import 'package:my_warehouse/screens/Estoque.dart';
import 'package:my_warehouse/screens/None.dart';

final Color laranja = HexColor.fromHex("#CA5C2F");

class NavigationMenu extends StatefulWidget {
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState(){
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    List<Widget> _widgetOptions;
    var _widgets;
    _widgets = const<BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.kitchen),
        title: Text('Cozinhar', style: TextStyle(color: Colors.black87, fontFamily: "OpenSans"),),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.storage),
        title: Text('Estoque', style: TextStyle(color: Colors.black87, fontFamily: "OpenSans"),),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.trending_up),
        title: Text('Relatório', style: TextStyle(color: Colors.black87, fontFamily: "OpenSans")),
      ),
    ];

    _widgetOptions = <Widget>[
      Cozinhar(),
      Estoque(),
      NonePage()
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: _widgets,
        currentIndex: _selectedIndex,
        selectedItemColor: laranja,
        onTap: _onItemTapped,
      ),
    );
  }
}
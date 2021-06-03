import 'package:flutter/material.dart';
import 'package:freeflix/screens/movies.dart';
import 'package:freeflix/screens/series.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> screens = [Movies(), Series()];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FreeFlix'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Series")
        ],
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
      ),
      body: screens[_index],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:freeflix/screens/movie_detail.dart';

class Movies extends StatefulWidget {
  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  late Map movies;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance
        .reference()
        .child('movies')
        .orderByChild('released')
        .onValue
        .listen((event) {
      setState(() {
        _loading = false;
        movies = {};
        (event.snapshot.value as Map).keys.toList().reversed.forEach((element) {
          movies[element] = event.snapshot.value[element];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            itemCount: movies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.5),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      MovieDetail(data: movies[movies.keys.toList()[index]]),
                ));
              },
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: movies[movies.keys.toList()[index]]['poster'],
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      movies[movies.keys.toList()[index]]['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

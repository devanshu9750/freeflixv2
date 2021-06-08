import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:freeflix/screens/series_detail.dart';

class Series extends StatefulWidget {
  const Series({Key? key}) : super(key: key);

  @override
  _SeriesState createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  late Map series;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance
        .reference()
        .child('series')
        .orderByChild('released')
        .onValue
        .listen((event) {
      setState(() {
        _loading = false;
        series = {};
        (event.snapshot.value as Map).keys.toList().reversed.forEach((element) {
          series[element] = event.snapshot.value[element];
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
            itemCount: series.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.5),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SeriesDetail(
                    data: series[series.keys.toList()[index]],
                  ),
                ));
              },
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: series[series.keys.toList()[index]]['poster'],
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      series[series.keys.toList()[index]]['title'],
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

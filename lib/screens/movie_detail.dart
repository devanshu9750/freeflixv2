import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freeflix/screens/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// https://drive.google.com/uc?export=download&id=1Ez7VjeNodFFULo2CeUPIH_KPvywfDEFS
// https://streamtape.com/v/4yx08BV8jlhKgAL/Catch_Me_If_You_Can_%282002%29.mp4

class MovieDetail extends StatelessWidget {
  final Map data;

  const MovieDetail({Key? key, required this.data}) : super(key: key);

  errorWidget(String streamtape, String gdrive, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error !!"),
        content: Text(
            "There was some error in streaming this video. But you can also download or stream in browser"),
        actions: [
          TextButton(
            onPressed: () {
              launch(
                  'https://drive.google.com/uc?export=download&id=' + gdrive);
            },
            child: Text('Download'),
          ),
          TextButton(
            onPressed: () {
              launch('https://streamtape.com/v/' + streamtape);
            },
            child: Text('Stream in browser'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Please wait for few seconds...")
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
            ),
          );

          String key = 'ZzLzMVqjglTqLXW';
          String username = 'd8e7f7202de8db46cb75';

          http.Response response = await http.get(Uri.parse(
              'https://api.streamtape.com/file/dlticket?file=' +
                  data['streamtape'] +
                  '&login=' +
                  username +
                  '&key=' +
                  key));

          if (jsonDecode(response.body)['status'] != 200) {
            Navigator.of(context).pop();
            errorWidget(data['streamtape'], data['gdrive'], context);
            return;
          }

          await Future.delayed(Duration(
              seconds: jsonDecode(response.body)['result']['wait_time']));

          response = await http.get(Uri.parse(
              'https://api.streamtape.com/file/dl?file=' +
                  data['streamtape'] +
                  '&ticket=' +
                  jsonDecode(response.body)['result']['ticket'] +
                  '&login=' +
                  username +
                  '&key=' +
                  key));

          if (jsonDecode(response.body)['status'] != 200) {
            Navigator.of(context).pop();
            errorWidget(data['streamtape'], data['gdrive'], context);
            return;
          }

          Navigator.of(context).pop();

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPlayer(
              url: jsonDecode(response.body)['result']['url'],
              subtitleUrl: data['subtitle'],
            ),
          ));
        },
        child: Icon(Icons.play_arrow),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 100,
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Please wait for few seconds...")
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                  ),
                );

                String key = 'ZzLzMVqjglTqLXW';
                String username = 'd8e7f7202de8db46cb75';

                http.Response response = await http.get(Uri.parse(
                    'https://api.streamtape.com/file/dlticket?file=' +
                        data['streamtape'] +
                        '&login=' +
                        username +
                        '&key=' +
                        key));

                if (jsonDecode(response.body)['status'] != 200) {
                  Navigator.of(context).pop();
                  launch('https://drive.google.com/uc?export=download&id=' +
                      data['gdrive']);
                  return;
                }

                await Future.delayed(Duration(
                    seconds: jsonDecode(response.body)['result']['wait_time']));

                response = await http.get(Uri.parse(
                    'https://api.streamtape.com/file/dl?file=' +
                        data['streamtape'] +
                        '&ticket=' +
                        jsonDecode(response.body)['result']['ticket'] +
                        '&login=' +
                        username +
                        '&key=' +
                        key));

                if (jsonDecode(response.body)['status'] != 200) {
                  Navigator.of(context).pop();
                  launch('https://drive.google.com/uc?export=download&id=' +
                      data['gdrive']);
                  return;
                }

                Navigator.pop(context);
                launch(jsonDecode(response.body)['result']['url']);
              },
              icon: Icon(Icons.download))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Container(
                    height: 200,
                    width: (MediaQuery.of(context).size.width / 3),
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: data['poster'],
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      data['title'],
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      data['genre'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.yellow, width: 1)),
                          elevation: 10,
                          color: Color.fromRGBO(31, 31, 31, 1),
                          child: Container(
                            height: 80,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data['imdbrating'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Text(
                                  "IMDb",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.green, width: 1)),
                          elevation: 10,
                          color: Color.fromRGBO(31, 31, 31, 1),
                          child: Container(
                              height: 80,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['runtime'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Duration",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blue, width: 1)),
                    elevation: 10,
                    color: Color.fromRGBO(31, 31, 31, 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Plot',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 12, top: 10),
                            child: Text(
                              data['plot'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side:
                          BorderSide(color: Colors.deepPurpleAccent, width: 1)),
                  elevation: 10,
                  color: Color.fromRGBO(31, 31, 31, 1),
                  child: Container(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text("Release Date"),
                          Text(
                            data['released'].split('-')[2] +
                                "-" +
                                data['released'].split('-')[1] +
                                "-" +
                                data['released'].split('-')[0],
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freeflix/screens/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatelessWidget {
  final Map data;

  const MovieDetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Please wait...')
                  ],
                ),
              ),
            ),
          ),
        );

        final String key = 'vYQG2qKLdZS4y30';
        final String username = '298d0a3f487880089edb';

        http.Response video = await http.get(Uri.parse(
            'https://api.streamtape.com/file/dlticket?file=' +
                data['id'] +
                '&login=' +
                username +
                '&key=' +
                key));

        if (jsonDecode(video.body)['status'] != 200) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error !!'),
              content: Text(
                  'Too much traffic on servers. Plz try again later Or you can open in browser (but contains lots of ads).'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await canLaunch('https://streamtape.com/e/' + data['id'])
                          ? await launch(
                              'https://streamtape.com/e/' + data['id'])
                          : throw 'Could not launch';
                      Navigator.of(context).pop();
                    },
                    child: Text('Open in Browser')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok'))
              ],
            ),
          );
          return;
        }

        await Future.delayed(
            Duration(seconds: jsonDecode(video.body)['result']['wait_time']));

        video = await http.get(Uri.parse(
            'https://api.streamtape.com/file/dl?file=' +
                data['id'] +
                '&ticket=' +
                jsonDecode(video.body)['result']['ticket'] +
                '&login=' +
                username +
                '&key=' +
                key));

        if (jsonDecode(video.body)['status'] != 200) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error !!'),
              content: Text(
                  'Too much traffic on servers. Plz try again later Or you can open in browser (but contains lots of ads).'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await canLaunch('https://streamtape.com/e/' + data['id'])
                          ? await launch(
                              'https://streamtape.com/e/' + data['id'])
                          : throw 'Could not launch';
                      Navigator.of(context).pop();
                    },
                    child: Text('Open in Browser')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok'))
              ],
            ),
          );
          return;
        }

        String videoUrl = jsonDecode(video.body)['result']['url'];

        Navigator.of(context).pop();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VideoPlayer(
            url: videoUrl,
            subtitleUrl: data['subtitle'],
          ),
        ));
      }),
    );
  }
}

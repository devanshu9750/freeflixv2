import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String url;
  final String? subtitleUrl;

  const VideoPlayer({Key? key, required this.url, this.subtitleUrl})
      : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.url,
        subtitles: (widget.subtitleUrl == null)
            ? null
            : BetterPlayerSubtitlesSource.single(
                selectedByDefault: true,
                type: BetterPlayerSubtitlesSourceType.network,
                url: widget.subtitleUrl));

    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          fullScreenByDefault: true,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20, fontColor: Colors.yellow),
          controlsConfiguration: BetterPlayerControlsConfiguration(
              skipBackIcon: CupertinoIcons.gobackward_15,
              skipForwardIcon: CupertinoIcons.goforward_15,
              backwardSkipTimeInMilliseconds: 15000,
              forwardSkipTimeInMilliseconds: 15000),
        ),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: _betterPlayerController,
          ),
        ),
      ),
    );
  }
}

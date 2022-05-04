import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../utils/color.dart';

class PlayerSection extends StatefulWidget {
  const PlayerSection(this.url, {Key? key}) : super(key: key);

  final String url;
  @override
  State<PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<PlayerSection> {
  late AudioPlayer player;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  ButtonState btnState = ButtonState.loading;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    init();
    // Player.getInstance().notify = () => setState(() {});
    // Player.getInstance().play(widget.url);
  }

  void init() async {
    player = AudioPlayer();

    player.playerStateStream.listen((event) {
      var processingState = event.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        btnState = ButtonState.loading;
        print('loading');
        setState(() {});
        return;
      }

      var isPlaying = event.playing;
      btnState = isPlaying ? ButtonState.playing : ButtonState.paused;
      print(isPlaying ? 'playing' : 'paused');
      setState(() {});
    });

    player.setUrl(widget.url).then((value) {
      setState(() {
        duration = value!;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _duration = duration.inSeconds;
    var _position = position.inSeconds;
    var _scrWidth = MediaQuery.of(context).size.width;

    Widget playBtn;

    switch (btnState) {
      case ButtonState.loading:
        playBtn = Container(
          margin: const EdgeInsets.all(8.0),
          width: 32.0,
          height: 32.0,
          child: const CircularProgressIndicator(),
        );
        break;
      case ButtonState.playing:
        playBtn = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    player.pause();
                  },
                  icon: const Icon(Icons.pause_circle_filled_rounded,
                      color: mainBlue, size: 76)),
              const SizedBox(width: 45)
            ]);
        break;
      case ButtonState.paused:
        playBtn = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    player.play();
                  },
                  icon: const Icon(Icons.play_circle_filled_rounded,
                      color: mainBlue, size: 76)),
              const SizedBox(width: 45)
            ]);
        break;
    }

    return Container(
        height: 240,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(30), topEnd: Radius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 10),
            Text(
              'Preview',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade600),
            ),

            // Progress bar and Play time
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  child: Slider(
                    value: (_duration != 0 ? _position / _duration : 0),
                    label: _secToMin(_position.toInt()),
                    onChanged: (newRating) {
                      //setState(() {});
                    },
                    onChangeEnd: (newRating) {
                      player
                          .seek(Duration(
                              seconds: (newRating * _duration).toInt()))
                          .then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  padding: EdgeInsets.symmetric(horizontal: _scrWidth * 0.035),
                ),

                // Play time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _scrWidth * 0.2,
                      child: Center(
                          child: Text(_secToMin(_position.toInt()),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700))),
                    ),
                    SizedBox(
                        width: _scrWidth * 0.2,
                        child: Center(
                            child: Text(_secToMin(_duration.toInt()),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700))))
                  ],
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            player.play();                                                                                                                                                                                                                                                                                                                        
                          },
                          icon: const Icon(Icons.play_circle_filled_rounded,
                              color: mainBlue, size: 76)),
                      const SizedBox(width: 45)
                    ]),
                const SizedBox(height: 15),
              ],
            ),
            const SizedBox(height: 60)
          ],
        ));
  }
}

String _secToMin(int sec) {
  var _min = sec ~/ 60;
  var _sec = sec % 60;
  return '${_min < 10 ? '0' + _min.toString() : _min}:${_sec < 10 ? '0' + _sec.toString() : _sec}';
}

enum ButtonState { loading, playing, paused }

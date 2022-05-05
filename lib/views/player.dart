import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../services/player.dart';
import '../utils/color.dart';

class PlayerSection extends StatefulWidget {
  const PlayerSection(this.url, {Key? key}) : super(key: key);

  final String url;
  @override
  State<PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<PlayerSection> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Player.getInstance().notify = (ButtonState _btnState) => setState(() {
    //       btnState = _btnState;
    //     });

    // set url
    Player.getInstance().setUrl(widget.url).then((value) {
      setState(() {
        duration = value;
      });
    }).catchError((e) {
      print('E: setUrl ' + e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var _duration = duration.inSeconds;
    var _position = position.inSeconds;
    var _scrWidth = MediaQuery.of(context).size.width;

    //Widget playBtn;
    // switch (btnState) {
    //   case ButtonState.loading:
    //     playBtn = Container(
    //       margin: const EdgeInsets.all(8.0),
    //       width: 32.0,
    //       height: 32.0,
    //       child: const CircularProgressIndicator(),
    //     );
    //     break;
    //   case ButtonState.playing:
    //     playBtn = Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           IconButton(
    //               onPressed: Player.getInstance().pause,
    //               icon: const Icon(Icons.pause_circle_filled_rounded,
    //                   color: mainBlue, size: 76)),
    //           const SizedBox(width: 45)
    //         ]);
    //     break;
    //   case ButtonState.paused:
    //     playBtn = Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           IconButton(
    //               onPressed: Player.getInstance().play,
    //               icon: const Icon(Icons.play_circle_filled_rounded,
    //                   color: mainBlue, size: 76)),
    //           const SizedBox(width: 45)
    //         ]);
    //     break;
    //   case ButtonState.replay:
    //     playBtn = Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           IconButton(
    //               onPressed: Player.getInstance().replay,
    //               icon: const Icon(Icons.replay_circle_filled_rounded,
    //                   color: mainBlue, size: 76)),
    //           const SizedBox(width: 45)
    //         ]);
    //     break;
    // }

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
                    value: ((_duration != 0) ? (_position / _duration) : 0)
                        .toDouble(),
                    label: _secToMin(_position),
                    onChanged: (newRating) {
                      setState(() {
                        position = Duration(
                            seconds: (newRating * duration.inSeconds).toInt());
                      });
                    },
                    onChangeEnd: (newRating) {
                      // player seek
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
                          child: Text(_secToMin(_position),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700))),
                    ),
                    SizedBox(
                        width: _scrWidth * 0.2,
                        child: Center(
                            child: Text(_secToMin(_duration),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700))))
                  ],
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ElevatedButton(
                //         onPressed: Player.getInstance().play,
                //         child: Text('play')),
                //     ElevatedButton(
                //         onPressed: Player.getInstance().pause,
                //         child: Text('pause'))
                //   ],
                // ),

                const _PlayButton(),

                //const SizedBox(height: 15),
              ],
            ),
            const SizedBox(height: 60)
          ],
        ));
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key}) : super(key: key);

  // final Widget playBtn = Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       IconButton(
  //           onPressed: Player.getInstance().play,
  //           icon: const Icon(Icons.play_circle_filled_rounded,
  //               color: mainBlue, size: 76)),
  //       const SizedBox(width: 45)
  //     ]);
  // final Widget pauseBtn = Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       IconButton(
  //           onPressed: Player.getInstance().pause,
  //           icon: const Icon(Icons.pause_circle_filled_rounded,
  //               color: mainBlue, size: 76)),
  //       const SizedBox(width: 45)
  //     ]);
  // final Widget replayBtn = Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       IconButton(
  //           onPressed: Player.getInstance().replay,
  //           icon: const Icon(Icons.replay_circle_filled_rounded,
  //               color: mainBlue, size: 76)),
  //       const SizedBox(width: 45)
  //     ]);
  // final Widget loading = Container(
  //   margin: const EdgeInsets.all(8.0),
  //   width: 32.0,
  //   height: 32.0,
  //   child: const CircularProgressIndicator(),
  // );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: Player.getInstance().playerStateStream,
      builder: (context, snapshot) {
        var playerState = snapshot.data;
        if (playerState == null) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 32.0,
            height: 32.0,
            child: const CircularProgressIndicator(),
          );
        }

        if (playerState.processingState == ProcessingState.ready) {
          // Playing state, press to pause
          if (playerState.playing) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: Player.getInstance().pause,
                      icon: const Icon(Icons.pause_circle_filled_rounded,
                          color: mainBlue, size: 76)),
                  const SizedBox(width: 45)
                ]);
          }

          // Pausing state, press to play
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: Player.getInstance().play,
                    icon: const Icon(Icons.play_circle_filled_rounded,
                        color: mainBlue, size: 76)),
                const SizedBox(width: 45)
              ]);
        }

        if (playerState.playing &&
            playerState.processingState == ProcessingState.completed) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: Player.getInstance().replay,
                    icon: const Icon(Icons.replay_circle_filled_rounded,
                        color: mainBlue, size: 76)),
                const SizedBox(width: 45)
              ]);
        }

        return Container(
          margin: const EdgeInsets.all(8.0),
          width: 32.0,
          height: 32.0,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}

String _secToMin(int sec) {
  var _min = sec ~/ 60;
  var _sec = sec % 60;
  return '${_min < 10 ? '0' + _min.toString() : _min}:${_sec < 10 ? '0' + _sec.toString() : _sec}';
}

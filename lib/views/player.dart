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
  Duration duration = const Duration(seconds: 1);
  //Duration position = Duration.zero;

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
    return Container(
        //height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(30), topEnd: Radius.circular(30)),
        ),
        child: (widget.url != ''
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
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

                  Stack(children: [
                    _ProgressBar(duration),
                    Center(
                        child: Column(
                      children: const [
                        // half of progress indicator bar height
                        SizedBox(height: 24),

                        SizedBox(height: 115, width: 76, child: _PlayButton())
                      ],
                    ))
                  ]),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     // Container(
                  //     //     decoration: BoxDecoration(color: Colors.amber),
                  //     //     height: 64,
                  //     //     child:
                  //     _ProgressBar(duration),
                  //     //   ),
                  //     const _PlayButton(),
                  //   ],
                  // ),
                  //const SizedBox(height: 5)
                ],
              )
            : Center(
                child: Text(
                  'No preview',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade600),
                ),
              )));
  }
}

class _BufferBar extends StatelessWidget {
  const _BufferBar(this.duration, {Key? key}) : super(key: key);
  final Duration duration;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: Player.getInstance().bufferedPositionStream,
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              color: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.surface,
              value: (snapshot.hasData ? snapshot.data! : Duration.zero)
                      .inMilliseconds /
                  duration.inMilliseconds,
              //semanticsLabel: 'Linear progress indicator',
            ),
          );
        });
  }
}

class _ProgressBar extends StatefulWidget {
  const _ProgressBar(this.duration, {Key? key}) : super(key: key);
  final Duration duration;
  @override
  State<_ProgressBar> createState() => __ProgressBarState();
}

class __ProgressBarState extends State<_ProgressBar> {
  Duration position = Duration.zero;
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    // var _scrWidth = MediaQuery.of(context).size.width;
    // Duration _position = position;
    // var _duration = widget.duration != Duration.zero
    //     ? widget.duration
    //     : const Duration(seconds: 1);
    // return Column(
    //   children: [
    //     Padding(
    //       child: Slider(
    //         value: _position.inMilliseconds / _duration.inMilliseconds,
    //         label: _secToMin(_position),
    //         onChanged: (newRating) {
    //           print('onChange');
    //           setState(() {
    //             position = Duration(
    //                 milliseconds:
    //                     (newRating * _duration.inMilliseconds).toInt());
    //           });
    //         },
    //         onChangeStart: (double startValue) {
    //           print('onChangeStart');
    //           //isDragging = true;
    //         },
    //         onChangeEnd: (newRating) {
    //           print('onChangeEnd');
    //           // isDragging = false;
    //           // // player seek
    //           // Player.getInstance().seek(Duration(
    //           //     milliseconds:
    //           //         (newRating * _duration.inMilliseconds).toInt()));
    //         },
    //       ),
    //       padding: EdgeInsets.symmetric(horizontal: _scrWidth * 0.04),
    //     ),

    //     // Play time and PlayButton
    //     Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //             width: _scrWidth * 0.2,
    //             child: Center(
    //                 child: Text(_secToMin(_position),
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.grey.shade700))),
    //           ),
    //           SizedBox(
    //               width: _scrWidth * 0.2,
    //               child: Center(
    //                   child: Text(_secToMin(_duration),
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.bold,
    //                           color: Colors.grey.shade700))))
    //         ])
    //   ],
    // );

    return StreamBuilder<Duration>(
        stream: Player.getInstance().positionStream,
        builder: (context, snapshot) {
          var _scrWidth = MediaQuery.of(context).size.width;
          var _duration = widget.duration;

          var sourcePosition = snapshot.hasData ? snapshot.data : Duration.zero;

          double sliderValue;

          if (isDragging) {
            sliderValue = position.inMilliseconds / _duration.inMilliseconds;
          } else {
            sliderValue =
                sourcePosition!.inMilliseconds / _duration.inMilliseconds;
            position = sourcePosition;
          }

          if (sliderValue > 1) sliderValue = 1;
          return Column(
            children: [
              // progress Indicator bar
              Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: _scrWidth * 0.1),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  // Buffer
                  _BufferBar(_duration),

                  // Indicator

                  SliderTheme(
                      data: SliderThemeData(
                        trackShape: _CustomTrackShape(),
                      ),
                      child: Slider(
                        value: sliderValue,
                        label: _secToMin(position),
                        onChanged: (newRating) {
                          setState(() {
                            position = Duration(
                                milliseconds:
                                    (newRating * _duration.inMilliseconds)
                                        .toInt());
                          });
                        },
                        onChangeStart: (double startValue) {
                          isDragging = true;
                          //isDragging = true;
                        },
                        onChangeEnd: (newRating) {
                          isDragging = false;

                          // // player seek
                          Player.getInstance().seek(Duration(
                              milliseconds:
                                  (newRating * _duration.inMilliseconds)
                                      .toInt()));
                        },
                      )),
                ]),
              ),

              // Play time
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _scrWidth * 0.2,
                      child: Center(
                          child: Text(_secToMin(position),
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
                  ])
            ],
          );
        });
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 76,
        height: 76,
        child: StreamBuilder<PlayerState>(
          stream: Player.getInstance().playerStateStream,
          builder: (context, snapshot) {
            var playerState = snapshot.data;
            if (playerState == null) {
              return const _LoadingIcon();
            }

            if (playerState.processingState == ProcessingState.ready) {
              // Playing state, press to pause
              if (playerState.playing) {
                return IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: Player.getInstance().pause,
                    icon: const Icon(Icons.pause_circle_filled_rounded,
                        color: mainBlue, size: 76));
              }

              // Pausing state, press to play
              return IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: Player.getInstance().play,
                  icon: const Icon(Icons.play_circle_filled_rounded,
                      color: mainBlue, size: 76));
            }

            if (playerState.playing &&
                playerState.processingState == ProcessingState.completed) {
              return IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: Player.getInstance().replay,
                  icon: const Icon(Icons.replay_circle_filled_rounded,
                      color: mainBlue, size: 76));
            }

            return const _LoadingIcon();
          },
        ));
    ;
  }
}

String _secToMin(Duration duration) {
  var secs = duration.inSeconds;
  var _min = secs ~/ 60;
  var _sec = secs % 60;
  return '${_min < 10 ? '0' + _min.toString() : _min}:${_sec < 10 ? '0' + _sec.toString() : _sec}';
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 76,
        width: 76,
        child: Center(child: CircularProgressIndicator()));
  }
}

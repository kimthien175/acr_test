import 'package:acr_test/models/deezer_song.dart';
import 'package:flutter/material.dart';

import '../utils/color.dart';

class SongScreen extends StatefulWidget {
  const SongScreen(this.song, {Key? key}) : super(key: key);

  final DeezerSong song;
  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final int _present = 0;
  int _duration = 0;
  bool _isPlaying = false;
  String _contributers = '_contributer';
  @override
  Widget build(BuildContext context) {
    _duration = widget.song.duration as int;

    // convert contributers to string
    var contributers = widget.song.contributors;
    if (contributers!.isNotEmpty) {
      _contributers = '';
      if (contributers.length > 1) {
        var i = 0;
        for (; i < contributers.length - 1; i++) {
          _contributers =
              _contributers + contributers[i].name.toString() + ' & ';
        }
        _contributers = _contributers +
            contributers[contributers.length - 1].name.toString();
      } else {
        _contributers = contributers.first.name.toString();
      }
    }
    var _scrHeight = MediaQuery.of(context).size.height;
    var _scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded)),
          flexibleSpace: gradientContainer(),
          elevation: 0,
        ),
        body: gradientContainer(
          child: SizedBox(
            height: _scrHeight,
            width: _scrWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: (widget.song.album!.coverMedium != null)
                      ? Image.network(widget.song.album!.coverMedium.toString(),
                          loadingBuilder: ((context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }))
                      : Container(
                          padding: const EdgeInsets.all(40),
                          height: 250,
                          width: 250,
                          decoration:
                              const BoxDecoration(color: Color(0xFFFFFFFF)),
                          child: Image.asset(
                            'assets/images/shazam-logo.png',
                            color: mainBlue,
                          ),
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.song.title! ?? 'Track name',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      _contributers,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                // Play section
                Container(
                    height: 240,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(30),
                          topEnd: Radius.circular(30)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 30),
                        // Progress bar and Play time
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Progress bar
                            Container(
                              height: 5,
                              width: _scrWidth * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 15),

                            // Play time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: _scrWidth * 0.2,
                                  child: Center(
                                      child: Text(_secToMin(_present),
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
                          ],
                        ),
                        // Play button
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPlaying = !_isPlaying;
                                    });
                                  },
                                  icon: Icon(
                                      _isPlaying
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_filled_rounded,
                                      color: mainBlue,
                                      size: 75)),
                              const SizedBox(width: 45)
                            ]),
                        const SizedBox(height: 50)
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}

String _secToMin(int sec) {
  var _min = sec ~/ 60;
  var _sec = sec % 60;
  return '${_min < 10 ? '0' + _min.toString() : _min}:${_sec < 10 ? '0' + _sec.toString() : _sec}';
}

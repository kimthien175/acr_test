import 'package:acr_test/models/deezer_song.dart';
import 'package:acr_test/views/song.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import '../controller/controller.dart';
import '../services/acr.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Controller.getInstance().reloadHome = () => setState(() {});
    Controller.getInstance().navigateTo = (DeezerSong song) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SongScreen(song)),
        );

    _breathingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    _breathingController.addListener(() {
      setState(() {
        _breather = _breathingController.value;
      });
    });

    _breathingController.forward();
  }

  late AnimationController _breathingController;
  var _breather = 0.0;

  @override
  Widget build(BuildContext context) {
    var _acr = Acr.getInstance();
    return Scaffold(
        backgroundColor: const Color(0xFF042442),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Tap to Shazam',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                AvatarGlow(
                  endRadius: 200.0,
                  animate: _acr.isRecognizing,
                  child: GestureDetector(
                    onTap: _acr.isRecognizing ? _acr.stop : _acr.start,
                    child: Material(
                      shape: const CircleBorder(),
                      elevation: 8,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        height: 200 * (1 + _breather * 0.06),
                        width: 200 * (1 + _breather * 0.06),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF089af8)),
                        child: Image.asset(
                          'assets/images/shazam-logo.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}

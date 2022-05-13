import 'package:acr_test/models/deezer_song.dart';
import 'package:acr_test/utils/color.dart';
import 'package:acr_test/views/song.dart';
import 'package:acr_test/widgets/scrollable_bottom_sheet.dart';
import 'package:acr_test/widgets/track_card.dart';
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
  bool hasError = false;
  @override
  void initState() {
    super.initState();

    Controller.getInstance().reloadHome =
        (bool hasError, {List<DeezerSong>? resultList}) {
      setState(() {
        this.hasError = hasError;
      });
      if (resultList != null) {
        showScrollableBottomSheet(
            context, resultList.map((e) => TrackCard(e)).toList());
      }
    };

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

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  late AnimationController _breathingController;
  var _breather = 0.0;

  @override
  Widget build(BuildContext context) {
    var _acr = Acr.getInstance();
    return Scaffold(
        body: gradientContainer(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _acr.isRecognizing
                          ? 'Listeing...'
                          : (hasError ? 'Please try again' : 'Tap to Shazam'),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
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
                                shape: BoxShape.circle,
                                color: Color(0xFFFFFFFF)),
                            child: Image.asset(
                              'assets/images/shazam-logo.png',
                              color: mainBlue,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}

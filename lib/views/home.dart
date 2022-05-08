import 'package:acr_test/models/deezer_song.dart';
import 'package:acr_test/utils/color.dart';
import 'package:acr_test/views/song.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
        showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          context: context,
          builder: (BuildContext context) {
            return Column(
              children: [
                ListView(
                  children: [
                    //  ...resultList.map((song) => FoundTrackCard(song)).toList(),
                    Container(
                        height: 5,
                        width: 50,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    FoundTrackCard(resultList[0]),
                    FoundTrackCard(resultList[0]),
                    FoundTrackCard(resultList[0]),
                    // FoundTrackCard(resultList[0]),
                    // FoundTrackCard(resultList[0]),
                    // FoundTrackCard(resultList[0]),
                    // FoundTrackCard(resultList[0]),
                    const SizedBox(height: 15)
                  ],
                ),
              ],
            );
          },
          // constraints: BoxConstraints.
        );
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

class FoundTrackCard extends StatelessWidget {
  const FoundTrackCard(this.song, {Key? key}) : super(key: key);
  final DeezerSong song;
  @override
  Widget build(BuildContext context) {
    var _contributers = '';
    var contributers = song.contributors;
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

    var _scrWidth = MediaQuery.of(context).size.width;

    return Container(
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        decoration: const BoxDecoration(
            color: cardBlue,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          children: [
            // Track cover
            Container(
              //padding: const EdgeInsets.all(40),
              margin: EdgeInsets.all(8),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (song.album!.coverMedium != null)
                      ? Image.network(song.album!.coverMedium.toString(),
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
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/shazam-logo.png',
                            color: mainBlue,
                          ))),
            ),

            const SizedBox(width: 10),
            SizedBox(
                height: 80,
                width: _scrWidth - 134,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      song.title!,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                    ),
                    AutoSizeText(_contributers,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.black54))
                  ],
                ))
          ],
        ));
  }
}

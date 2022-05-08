import 'package:acr_test/models/deezer_song.dart';
import 'package:acr_test/utils/color.dart';
import 'package:acr_test/views/player.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            //decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Column(
      children: [
        Spacer(),
        // Column(
        //   children: [
        //     _FoundTrackCard(),
        //     _FoundTrackCard(),
        //     _FoundTrackCard(),
        //     SizedBox(height: 15)
        //   ],
        // ),
      ],
    )));
  }
}

class _FoundTrackCard extends StatelessWidget {
  const _FoundTrackCard(this.song, {Key? key}) : super(key: key);
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
    return Container(
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
        decoration: const BoxDecoration(
            color: cardBlue,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          children: [
            Container(
              //padding: const EdgeInsets.all(40),
              margin: EdgeInsets.all(8),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8)),
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
                      )),
            ),
            const SizedBox(width: 10),
            SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        //song.title!,
                        'Title',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54)),
                    Text(_contributers,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.black54))
                  ],
                ))
          ],
        ));
  }
}

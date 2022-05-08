import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/deezer_song.dart';
import '../utils/color.dart';
import '../views/song.dart';

class TrackCard extends StatelessWidget {
  const TrackCard(this.song, {Key? key}) : super(key: key);
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

    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SongScreen(song)),
            ),
        child: Container(
            margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: cardBlue,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(
              children: [
                // Track cover
                Container(
                  margin: const EdgeInsets.all(8),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (song.album!.coverMedium != null)
                          ? Image.network(song.album!.coverMedium.toString(),
                              loadingBuilder:
                                  ((context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }))
                          : Padding(
                              padding: const EdgeInsets.all(10),
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
                              color: Color(0XFF239BFE),
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                        ),
                        AutoSizeText(_contributers,
                            maxLines: 1,
                            minFontSize: 5,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54))
                      ],
                    ))
              ],
            )));
  }
}

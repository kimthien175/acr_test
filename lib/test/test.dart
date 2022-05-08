import 'package:acr_test/models/deezer_song.dart';
import 'package:acr_test/test/deezer_sample.dart';
import 'package:acr_test/utils/color.dart';
import 'package:acr_test/views/home.dart';
import 'package:acr_test/views/player.dart';
import 'package:acr_test/widgets/scrollable_bottom_sheet.dart';
import 'package:acr_test/widgets/track_card.dart';
import 'package:flutter/material.dart';

import '../views/song.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sample = DeezerSample.getInstance().get();
    // return Scaffold(
    //   body: Center(
    //       child: ElevatedButton(
    //           onPressed: () => showScrollableBottomSheet(context, [
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //                 TrackCard(sample),
    //               ]),
    //           child: Text('show bottom sheet'))),
    // );
    return SongScreen(sample);
  }
}

import 'package:acr_test/models/deezer_song.dart';
import 'package:flutter/material.dart';

class SongScreen extends StatefulWidget {
  const SongScreen(this.song, {Key? key}) : super(key: key);

  final DeezerSong song;
  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text(widget.song.title ?? 'SOng title')));
  }
}

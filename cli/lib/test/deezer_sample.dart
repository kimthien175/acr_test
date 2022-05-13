import 'dart:convert';

import '../models/deezer_song.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<DeezerSong> getDeezerSample() async {
  var result = await rootBundle.loadString('./assets/sample.json');
  return DeezerSong.fromJson(jsonDecode(result));
}

class DeezerSample {
  static final DeezerSample _instance = DeezerSample._internal();
  static DeezerSample getInstance() => _instance;
  DeezerSample._internal();

  Future<void> init() async {
    _sample = await getDeezerSample();
  }

  DeezerSong? _sample;
  DeezerSong get() => _sample!;
}

// DeezerSample.getInstance().set(DeezerSong song)
// get()

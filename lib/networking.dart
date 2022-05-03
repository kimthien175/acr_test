import 'dart:convert';

import 'package:http/http.dart' as http;

import './models/deezer_song.dart';

class Networking {
  static final Networking _instance = Networking._internal();
  static Networking getInstance() => _instance;
  Networking._internal();

  final String _url = 'https://api.deezer.com';

  Future<DeezerSong> get(String id) async {
    var result = await http.get(Uri.parse('$_url/track/$id'));
    if (result.statusCode == 200) {
      return DeezerSong.fromJson(jsonDecode(result.body));
    }
    throw Exception(result.body);
  }
}

import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Acr {
  static final Acr _instance = Acr._internal();
  static Acr getInstance() => _instance;
  Acr._internal();

  Future<void> init() async {
    _acr
      ..init(
          host: dotenv.env['acr_host'].toString(),
          accessKey: dotenv.env['acr_access_key'].toString(),
          accessSecret: dotenv.env['acr_access_secret'].toString(),
          setLog: false)
      ..songModelStream.listen(searchSong);
  }

  void searchSong(SongModel song) {
    print('searchSong');
    print(song.toJson());
    print('end searchSong');
  }

  final AcrCloudSdk _acr = AcrCloudSdk();

  Future<void> start() async {
    _acr.start().catchError((e) {
      print('Acr Start');
      print(e);

      print('Acr Start -> Stop');
    });
  }

  Future<void> stop() async {
    _acr.stop().catchError((e) {
      print(e);
    });
  }
}

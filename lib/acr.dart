import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:dotenv/dotenv.dart';

class Acr {
  static final Acr _instance = Acr._internal();
  static Acr getInstance() => _instance;
  Acr._internal() {
    var env = DotEnv(includePlatformEnvironment: true)..load();

    _acr = AcrCloudSdk()
      ..init(
          host: env['acr_host'].toString(),
          accessKey: env['acr_access_key'].toString(),
          accessSecret: env['acr_access_secret'].toString())
      ..songModelStream.listen(searchSong);
  }

  void searchSong(SongModel song) {
    print(song);
  }

  late final AcrCloudSdk _acr;

  Future<bool> start() async {
    return _acr.start();
  }

  Future<bool> stop() async {
    return _acr.stop();
  }
}

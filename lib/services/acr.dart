import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../controller/controller.dart';
import '../utils/networking.dart';

class Acr {
  static final Acr _instance = Acr._internal();
  static Acr getInstance() => _instance;
  Acr._internal();

  bool _isRecognizing = false;
  bool get isRecognizing => _isRecognizing;

  Future<void> init() async {
    _acr
      ..init(
          host: dotenv.env['acr_host'].toString(),
          accessKey: dotenv.env['acr_access_key'].toString(),
          accessSecret: dotenv.env['acr_access_secret'].toString(),
          setLog: false)
      ..songModelStream.listen(searchSong);
  }

  void searchSong(SongModel song) async {
    // set state
    _isRecognizing = false;
    Controller.getInstance().home!();

    var data = song.metadata;
    //print(data);
    if (data != null && data.music!.isNotEmpty) {
      String id = data.music![0].externalMetadata?.deezer?.track?.id ?? '';
      print(data.music![0].externalMetadata?.deezer?.track?.name);
      if (id != '') {
        var result = await Networking.getInstance()
            .get(data.music![0].externalMetadata?.deezer?.track?.id ?? '');
        //print(result.toJson());
        //showDeezerResult(result);
      } else {
        throw Exception('Null deezer id from acr!');
      }
    }
  }

  final AcrCloudSdk _acr = AcrCloudSdk();

  Future<void> start() async {
    _isRecognizing = true;
    Controller.getInstance().home!();
    _acr.start().catchError((e) {
      print(e);
    });
  }

  Future<void> stop() async {
    _acr.stop().then((value) {
      _isRecognizing = false;
      Controller.getInstance().home!();
    }).catchError((e) {
      print(e);
    });
  }
}

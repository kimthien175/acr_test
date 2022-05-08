import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:acr_test/models/deezer_song.dart';
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
    Controller.getInstance().reloadHome!(false);

    var data = song.metadata;
    //print(data);
    if (data != null && data.music!.isNotEmpty) {
      // TODO: MULTIPLE MUSIC SOURCE
      var resultList = await getAllDeezerSong(data.music!);
      if (resultList.isEmpty) {
        Controller.getInstance().reloadHome!(true);
      } else {
        // if (resultList.length == 1) {
        //   Controller.getInstance().navigateTo!(resultList[0]);
        // } else {
        //   // show bottom sheet
        //   Controller.getInstance().reloadHome!(false, resultList: resultList);
        // }

        Controller.getInstance().reloadHome!(false, resultList: resultList);
      }

      // String id = data.music![0].externalMetadata?.deezer?.track?.id ?? '';
      // print(data.music![0].externalMetadata?.deezer?.track?.name);
      // if (id != '') {
      //   DeezerSong result = await Networking.getInstance().get(id);
      //   Controller.getInstance().navigateTo!(result);
      //   //print(result.toJson());
      //   //showDeezerResult(result);
      // } else {
      //   throw Exception('Null deezer id from acr!');
      // }
    } else {
      Controller.getInstance().reloadHome!(true);
    }
  }

  final AcrCloudSdk _acr = AcrCloudSdk();

  Future<void> start() async {
    _isRecognizing = true;
    Controller.getInstance().reloadHome!(false);
    _acr.start().catchError((e) {
      print(e);
    });
  }

  Future<void> stop() async {
    _acr.stop().then((value) {
      _isRecognizing = false;
      Controller.getInstance().reloadHome!(false);
    }).catchError((e) {
      print(e);
    });
  }
}

Future<List<DeezerSong>> getAllDeezerSong(List<Music> list) async {
  List<Future<DeezerSong>> futureList = [];
  for (var item in list) {
    var deezer = item.externalMetadata!.deezer;
    if (deezer == null) continue;

    var id = deezer.track?.id;
    if (id == null) continue;

    futureList.add(Networking.getInstance().get(id));
  }
  return await Future.wait(futureList);
}

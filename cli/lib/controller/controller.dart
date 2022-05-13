import 'package:acr_test/models/deezer_song.dart';

class Controller {
  static final Controller _instance = Controller._internal();
  static Controller getInstance() => _instance;
  Controller._internal();
  void Function(bool hasError, {List<DeezerSong>? resultList})? reloadHome;
  //Function<(bool)=>{}>? reloadHome;
  Function? navigateTo;
}

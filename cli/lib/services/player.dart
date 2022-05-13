import 'package:just_audio/just_audio.dart';

class Player {
  static final Player _instance = Player._internal();
  static Player getInstance() => _instance;
  Player._internal() {
    init();
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  PlayerState get playerState => _player.playerState;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  //Duration get position => _player.position;

  late AudioPlayer _player;

  void init() async {
    _player = AudioPlayer();
  }

  void dispose() async {
    _player.dispose();
  }

  // return duration to PlayerSection
  Future<Duration> setUrl(String url) async {
    if (url == '') throw Exception('Player::setUrl : url is empty');
    var duration = await _player.setUrl(url);
    if (duration != null) return duration;
    throw Exception('Result from Player::setUrl is NULL !!');
  }

  void play() {
    _player.play();
  }

  void pause() {
    _player.pause();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  void replay() {
    _player.seek(Duration.zero);
  }
}

//enum ButtonState { loading, paused, playing, replay }

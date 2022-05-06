// // class Player {
// //   static final Player _instance = Player._internal();
// //   static Player getInstance() => _instance;

// //   late PlayerState _state = PlayerState.STOPPED;
// //   PlayerState get state => _state;

// //   Duration _position = Duration.zero;
// //   Duration get position => _position;

// //   Duration _duration = Duration.zero;
// //   Duration get duration => _duration;

// //   Function? notify;

// //   Player._internal() {
// //     _player = AudioPlayer();
// //     _player.setReleaseMode(ReleaseMode.STOP);

// //     print(_state);
// //     _player.onPlayerStateChanged.listen((PlayerState s) {
// //       _state = s;
// //       print(_state);
// //       notify!();
// //     });

// //     _player.onAudioPositionChanged.listen((Duration p) {
// //       _position = p;
// //       notify!();
// //     });

// //     _player.onDurationChanged.listen((Duration d) {
// //       _duration = d;
// //       //notify!();
// //     });

// //     _player.onPlayerError.listen((msg) {
// //       print('audioPlayer error : $msg');

// //       _state = PlayerState.STOPPED;
// //       _duration = Duration.zero;
// //       _position = Duration.zero;

// //       notify!();
// //     });
// //   }

// //   void dispose() {
// //     _player.dispose();
// //   }

// //   late AudioPlayer _player;

// //   // Future<void> setUrl(String url) async {
// //   //   _player.setUrl(url, isLocal: false).catchError((e) {
// //   //     print(e);
// //   //   });
// //   // }

// //   Future<void> play(String url) async {
// //     _player.play(url);
// //   }

// //   Future<void> pause() async {
// //     _player.pause().catchError((e) {
// //       print(e);
// //     });
// //   }

// //   Future<void> seek(double destination) async {
// //     _player
// //         .seek(Duration(milliseconds: (destination * 1000).toInt()))
// //         .catchError((e) {
// //       print(e);
// //     });
// //   }

// //   Future<void> resume() async {
// //     _player.resume().catchError((e) {
// //       print(e);
// //     });
// //   }
// // }

// import 'package:just_audio/just_audio.dart';

// class Player {
//   static final Player _instance = Player._internal();
//   static Player getInstance() => _instance;

//   final Duration _position = Duration.zero;
//   Duration get position => _position;

//   final Duration _duration = Duration.zero;
//   Duration get duration => _duration;

//   Function? notify;

//   Player._internal() {
//     _player = AudioPlayer();

//     _player.playerStateStream.listen((state) {
//   switch (state.processingState) {
//     case ProcessingState.idle:
//     break;
//     case ProcessingState.loading: ...
//     case ProcessingState.buffering: ...
//     case ProcessingState.ready: ...
//     case ProcessingState.completed: ...
//   }
// });

//   }

//   PlayerState getState(){
//     if (_player.playerState == PlayerState.)
//     return _player.playerState;}

//   void dispose() {
//     _player.dispose();
//   }

//   late final AudioPlayer _player;

//   Future<void> setUrl(String url) async {
//     _player.setUrl(url);
//   }

//   Future<void> play() async {
//     _player.play();
//   }

//   Future<void> pause() async {
//     _player.pause().catchError((e) {
//       print(e);
//     });
//   }

//   Future<void> seek(double destination) async {
//     _player
//         .seek(Duration(milliseconds: (destination * 1000).toInt()))
//         .catchError((e) {
//       print(e);
//     });
//   }

//   Future<void> resume() async {
//     _player.resume().catchError((e) {
//       print(e);
//     });
//   }
// }

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

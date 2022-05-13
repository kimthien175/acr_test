// import 'package:record/record.dart';

// class Recorder {
//   static final Recorder _instance = Recorder._internal();
//   Recorder._internal();
//   static Recorder getInstance() => _instance;

//   final Record _record = Record();

//   Future<void> start() async {
//     var hasPermission = await _record.hasPermission();
//     if (!hasPermission) {
//       // request permission
//       throw Exception('No record permission');
//     }

//     return _record.start(
//         //String? path,
//         encoder: AudioEncoder.aacLc,
//         bitRate: 128000,
//         samplingRate: 44100);
//   }

//   Future<bool> isRecording() async {
//     return _record.isRecording();
//   }

//   Future<void> stop() async {
//     await _record.stop();
//     return;
//   }
// }

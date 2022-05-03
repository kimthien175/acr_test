import 'package:acr_test/services/acr.dart';
import 'package:acr_test/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await Acr.getInstance().init().catchError((e) => print(e));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        //home: SongScreen(DeezerSong(title: 'Ride'))
        home: Home());
  }
}

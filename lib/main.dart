import 'package:acr_test/acr.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: Column(children: [
            ElevatedButton(
                onPressed: () {
                  Acr.getInstance().start();
                },
                child: const Text('Start')),
            ElevatedButton(
                onPressed: () {
                  Acr.getInstance().stop();
                },
                child: const Text('Stop'))
          ]),
        ),
      ),
    );
  }
}

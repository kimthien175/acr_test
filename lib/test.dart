import 'package:acr_test/views/player.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Column(
              children: const [
                Spacer(),
                PlayerSection(
                    'https://cdns-preview-2.dzcdn.net/stream/c-2347e1abbae97bf42ecc87834ef89c76-4.mp3'),
              ],
            )));
  }
}

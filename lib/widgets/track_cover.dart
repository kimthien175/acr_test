import 'package:flutter/material.dart';

import '../utils/color.dart';

class TrackCover extends StatelessWidget {
  const TrackCover(this.imgUrl, this.size, {Key? key}) : super(key: key);
  final double size;
  final String? imgUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: (imgUrl != null)
              ? Image.network(imgUrl.toString(), fit: BoxFit.fill,
                  loadingBuilder: ((context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }))
              : Padding(
                  padding: EdgeInsets.all(size / 8),
                  child: Image.asset(
                    'assets/images/shazam-logo.png',
                    color: mainBlue,
                  ))),
    );
  }
}

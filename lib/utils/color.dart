import 'package:flutter/material.dart';

const mainBlue = Color(0xFF0088FF);
const cardBlue = Color(0xFFE3F2FD);

Widget gradientContainer({Widget? child}) {
  return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0C71E0), Color(0xFF10A5F5)],
        ),
      ),
      child: child);
}

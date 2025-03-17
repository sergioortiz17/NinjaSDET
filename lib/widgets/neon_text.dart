import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool italic;

  const NeonText(this.text, {super.key, this.fontSize = 40, this.italic = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: Colors.white,
        shadows: [
          Shadow(blurRadius: 5, color: Colors.redAccent, offset: const Offset(0, 0)),
          Shadow(color: Colors.blueAccent, blurRadius: 20),
          Shadow(color: Colors.purpleAccent, blurRadius: 30),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

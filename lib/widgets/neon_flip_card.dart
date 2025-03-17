import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonFlipCard extends StatefulWidget {
  const NeonFlipCard({super.key});

  @override
  _NeonFlipCardState createState() => _NeonFlipCardState();
}

class _NeonFlipCardState extends State<NeonFlipCard> with SingleTickerProviderStateMixin {
  bool _flipped = false;
  late bool _isBug;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _isBug = Random().nextBool(); // Decide aleatoriamente si es un Bug o Feature

    // 🔄 Controlador de animación para el giro
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!_flipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _flipped = !_flipped;
    });

    if (_flipped) {
      Future.delayed(const Duration(seconds: 1), () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(_isBug ? '🐞 ¡Felicidades! Encontraste un Bug' : '✨ No es un bug, es una feature'),
            content: const Text('Sigue explorando para encontrar más.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isFront = _flipAnimation.value < (pi / 2);

          return Transform(
            transform: Matrix4.rotationY(_flipAnimation.value),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: isFront ? Colors.grey[900] : (_isBug ? Colors.red : Colors.green),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFront ? Colors.blueAccent : (_isBug ? Colors.redAccent : Colors.greenAccent),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isFront ? Colors.blueAccent.withOpacity(0.6) : (_isBug ? Colors.redAccent : Colors.greenAccent),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Transform(
                  transform: isFront ? Matrix4.identity() : Matrix4.rotationY(pi), // 🔄 Corrige la dirección del texto
                  alignment: Alignment.center,
                  child: Text(
                    isFront ? 'Presiona para girar' : (_isBug ? '🐞 Bug' : '✨ Feature'),
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: isFront ? Colors.blueAccent : (_isBug ? Colors.red : Colors.green),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

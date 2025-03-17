import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText

class TorreQAScreen extends StatefulWidget {
  const TorreQAScreen({super.key});

  @override
  _TorreQAScreenState createState() => _TorreQAScreenState();
}

class _TorreQAScreenState extends State<TorreQAScreen> {
  final ScrollController _scrollController = ScrollController();
  double _bombPositionY = 0.5; // Posición vertical (0.0 = arriba, 1.0 = abajo)
  double _bombPositionX = 0.5; // Posición horizontal (0.0 = izquierda, 1.0 = derecha)
  bool _hasWon = false;
  bool _toggleActivated = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startFalling();
  }

  void _startFalling() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_hasWon) {
        timer.cancel();
        return;
      }

      setState(() {
        _bombPositionY += 0.003; // 💣 La bomba cae más lentamente

        // La bomba no puede subir más arriba de la pantalla
        if (_bombPositionY < 0.05) _bombPositionY = 0.05;

        // Si la bomba toca los fuegos, explota y pierdes
        if (_bombPositionY >= 0.95) {
          _showGameOverDialog();
          timer.cancel();
        }
      });
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("💥 ¡BOOM! 💥"),
        content: const Text("La bomba explotó"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _bombPositionY = 0.5; // Reiniciar juego
                _bombPositionX = 0.5;
              });
              _startFalling();
            },
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🎉 ¡Ganaste! 🎉"),
        content: const Text("Has logrado salvar la bomba"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const NeonText('Bomba Scrool', fontSize: 22, italic: true),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 🔙 Volver a WelcomeScreen
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _bombPositionY -= 0.015; // 🔥 Movimiento vertical más controlado
              _bombPositionX += (scrollNotification.scrollDelta! * 0.0015); // ↔ Movimiento lateral más suave

              // Evitar que la bomba salga del área visible
              if (_bombPositionY < 0.05) _bombPositionY = 0.05;
              if (_bombPositionY > 0.95) _bombPositionY = 0.95;
              if (_bombPositionX < 0.05) _bombPositionX = 0.05;
              if (_bombPositionX > 0.95) _bombPositionX = 0.95;
            });
          }
          return true;
        },
        child: Stack(
          children: [
            // ☁️ Fondo con nubes ASCII en posiciones aleatorias (movimiento más lento)
            Positioned.fill(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: 30,
                itemBuilder: (context, index) {
                  if (index == 25) {
                    return Center(
                      child: SwitchListTile(
                        title: const Text(
                          "🛑 Desactivar Bomba",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        value: _toggleActivated,
                        onChanged: (bool value) {
                          setState(() {
                            _toggleActivated = value;
                            if (_toggleActivated) {
                              _hasWon = true;
                              _showWinDialog();
                            }
                          });
                        },
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 20, // Más separación entre nubes
                      left: _random.nextDouble() * (screenWidth - 100), // Posición aleatoria en X
                    ),
                    child: const Text(
                      "", // Nubes ASCII
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "Courier"),
                    ),
                  );
                },
              ),
            ),

            // 💣 Bomba que cae y se mueve lateralmente
            Positioned(
              left: (screenWidth * _bombPositionX) - 25,
              top: MediaQuery.of(context).size.height * _bombPositionY,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(color: Colors.redAccent, blurRadius: 15),
                  ],
                ),
                child: const Center(child: Text("💣", style: TextStyle(fontSize: 30))),
              ),
            ),

            // 🔥 Fuego en la parte inferior (zona de peligro)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
                    style: TextStyle(fontSize: 24, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

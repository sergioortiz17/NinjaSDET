import 'package:flutter/material.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonText("Próximamente", fontSize: 22, italic: true), // 🔥 NeonText en el título
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 80, color: Colors.cyanAccent),
            const SizedBox(height: 20),
            const NeonText( 
              "¡Estamos trabajando en esta función!", 
              fontSize: 20, 
              italic: true, 
            ), // 🔥 NeonText en el mensaje principal
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
              onPressed: () {
                Navigator.pop(context); // Regresar a la pantalla anterior
              },
              child: const Text("Volver", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

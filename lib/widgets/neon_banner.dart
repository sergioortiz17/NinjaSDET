import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText para aplicar el mismo efecto

class NeonBanner extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NeonBanner({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120, // Tamaño cuadrado
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent, width: 4), // 🔥 Borde cian neón
          boxShadow: [
            BoxShadow(color: Colors.cyanAccent.withOpacity(0.6), blurRadius: 15), // 🔥 Sombra cian neón
          ],
        ),
        child: Center(
          child: NeonText(
            title,
            fontSize: 22,
            italic: true, // 🔥 Mismo estilo que "Próximamente"
          ),
        ),
      ),
    );
  }
}

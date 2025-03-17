import 'package:flutter/material.dart';
import 'neon_text.dart'; // Importamos NeonText para mantener la coherencia visual

class FooterText extends StatelessWidget {
  const FooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: NeonText(
          'Created by Sergio Ortiz',
          fontSize: 12,
          italic: true,
        ),
      ),
    );
  }
}

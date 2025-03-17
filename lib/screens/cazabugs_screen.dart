import 'package:flutter/material.dart';
import '../widgets/neon_flip_card.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText

class CazaBugsScreen extends StatelessWidget {
  const CazaBugsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonText('Bug Hunters', fontSize: 22, italic: true),),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columnas
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: 4, // 4 cartas
        itemBuilder: (context, index) => const NeonFlipCard(),
      ),
    );
  }
}

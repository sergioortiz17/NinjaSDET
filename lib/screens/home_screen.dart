import 'package:flutter/material.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText
import 'coming_soon_screen.dart'; // Importamos la pantalla "Próximamente"

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _sliderValue = 50; // Valor inicial del slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonText('Scrool & Swipe & Grid', fontSize: 24, italic: true)), // 🔥 Título en neón
      body: SingleChildScrollView( // 🔥 Permite hacer scroll en toda la pantalla
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Banner Horizontal Scrolleable con NeonText 🔥
              const NeonText(
                'Destacados:',
                fontSize: 18,
                italic: true,
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 110,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBannerItem("Oferta", Icons.local_offer),
                      _buildBannerItem("Evento", Icons.event),
                      _buildBannerItem("Recomendado", Icons.thumb_up),
                      _buildBannerItem("Sorpresa", Icons.card_giftcard),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 Slider con NeonText 🔥
              const NeonText(
                'Selecciona un valor:',
                fontSize: 18,
                italic: true,
              ),
              Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                divisions: 10,
                activeColor: Colors.cyanAccent,
                inactiveColor: Colors.grey,
                label: _sliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // 🔥 Grid de botones con NeonText 🔥
              const NeonText(
                'Opciones:',
                fontSize: 18,
                italic: true,
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridButton(context, Icons.settings, "Config"),
                  _buildGridButton(context, Icons.shopping_cart, "Tienda"),
                  _buildGridButton(context, Icons.star, "Favoritos"),
                  _buildGridButton(context, Icons.notifications, "Notifs"),
                  _buildGridButton(context, Icons.message, "Mensajes"),
                  _buildGridButton(context, Icons.map, "Mapa"),
                  _buildGridButton(context, Icons.help, "Ayuda"),
                  _buildGridButton(context, Icons.videogame_asset, "Juegos"),
                  _buildGridButton(context, Icons.music_note, "Música"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 Método para construir el banner horizontal con NeonText
  Widget _buildBannerItem(String title, IconData icon) {
    return Container(
      width: 140,
      height: 80,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.5),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.cyanAccent),
          const SizedBox(height: 3),
          NeonText(title, fontSize: 11), // 🔥 NeonText en el banner
        ],
      ),
    );
  }

  // 🔥 Método para construir cada botón del grid con NeonText
  Widget _buildGridButton(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComingSoonScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.cyanAccent),
            const SizedBox(height: 5),
            NeonText(label, fontSize: 12), // 🔥 NeonText en los botones del Grid
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/neon_text.dart';
import '../widgets/neon_banner.dart';
import 'cazabugs_screen.dart';
import 'chat_nightmare_screen.dart';
import 'torre_qa_screen.dart';
import 'profile_screen.dart';
import 'dropdown_toggle_screen.dart';
import 'feedback_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;
  String? _selectedBanner;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔹 Función para abrir el modal de perfil
  void _openProfileModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileScreen(),
    );
  }

  // 🔥 Función para manejar la selección del banner y hacer que brille
  void _selectBanner(String title, Widget screen) {
    setState(() {
      _selectedBanner = title;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ).then((_) {
        setState(() {
          _selectedBanner = null;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonText('Ninja SDET⚡', fontSize: 24, italic: true),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.cyanAccent),
            onPressed: _openProfileModal,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: NeonText('Automating everything', fontSize: 16, italic: true)),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _selectedIndex == 1
                  ? [
                      _buildAnimatedBanner(
                        title: 'Bug Hunters 🐛',
                        screen: const CazaBugsScreen(),
                      ),
                      const SizedBox(height: 20),
                      _buildAnimatedBanner(
                        title: 'ChatBot🤖',
                        screen: const ChatNightmareScreen(),
                      ),
                      const SizedBox(height: 20),
                      _buildAnimatedBanner(
                        title: 'Bomba Scroll💥',
                        screen: const TorreQAScreen(),
                      ),
                    ]
                  : [
                      _buildAnimatedBanner(
                        title: 'Dropdown & Toggle',
                        screen: const DropdownToggleScreen(),
                      ),
                      const SizedBox(height: 20),
                      _buildAnimatedBanner(
                        title: 'Scrool & Swipe & Grid',
                        screen: const HomeScreen(),
                      ),
                      const SizedBox(height: 20),
                      _buildAnimatedBanner(
                        title: 'Text Area & Modal Chain',
                        screen: const FeedbackScreen(),
                      ),
                    ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white70,
        selectedIconTheme: const IconThemeData(size: 30, shadows: [
          Shadow(color: Colors.cyanAccent, blurRadius: 15),
        ]),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.cyanAccent, blurRadius: 10),
          ],
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'CommonTools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Games',
          ),
        ],
      ),
    );
  }

  // 🔥 Función que crea un NeonBanner con animación de brillo
  Widget _buildAnimatedBanner({required String title, required Widget screen}) {
    bool isSelected = _selectedBanner == title;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
            : [],
      ),
      child: NeonBanner(
        title: title,
        onTap: () => _selectBanner(title, screen),
      ),
    );
  }
}

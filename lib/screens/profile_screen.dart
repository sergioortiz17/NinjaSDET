import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart'; // 📌 Importamos para obtener la versión
import '../screens/login_screen.dart';
import '../widgets/neon_text.dart'; // Importamos el NeonText

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // 🔥 Función para cerrar sesión
  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Borra usuario y contraseña guardados

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // 🔥 Elimina el historial de navegación
    );
  }

  // 🔥 Función para obtener la versión de la app
  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return "Versión ${packageInfo.version}";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Obtener ancho de pantalla

    return Stack(
      children: [
        // 🔹 Fondo transparente que cierra el modal al tocar
        GestureDetector(
          onTap: () => Navigator.pop(context), // Cierra el modal al tocar afuera
          child: Container(
            width: screenWidth, // Cubre toda la pantalla
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.5), // Fondo semi-transparente
          ),
        ),

        // 🔹 Panel deslizante (Profile)
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: screenWidth * 0.5, // Ocupa la mitad de la pantalla
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // 🌟 Header del Drawer con NeonText
                ListTile(
                  leading: const Icon(Icons.account_circle, color: Colors.cyanAccent, size: 40),
                  title: const NeonText('Perfil', fontSize: 22, italic: true), // Neón aplicado
                ),
                const Divider(color: Colors.cyanAccent),

                // 📌 Opciones del perfil con NeonText
                ListTile(
                  title: const NeonText('Agregar alias', fontSize: 18),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const NeonText('Califica la app', fontSize: 18),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const NeonText('Cerrar sesión', fontSize: 18),
                  onTap: () => _logout(context), // 🔥 Llamamos la función para cerrar sesión
                ),

                const Spacer(),



                // 🌟 Footer "Created by Sergio Ortiz" con NeonText
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: NeonText(
                      'Created by Sergio Ortiz',
                      fontSize: 14,
                      italic: true,
                    ),
                  ),
                ),

                // 🔥 Número de versión (obtenido dinámicamente)
                FutureBuilder<String>(
                  future: _getAppVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text(
                          "Cargando versión...",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        snapshot.data ?? "Versión desconocida",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

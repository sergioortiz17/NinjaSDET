import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../screens/welcome_screen.dart';
import '../screens/register_screen.dart';
import '../widgets/neon_text.dart';
import '../widgets/footer_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  String _appVersion = "Versión desconocida";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  void _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "Versión ${packageInfo.version}";
    });
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 🔥 Recupera los datos guardados de SharedPreferences
    final savedUser = prefs.getString('user') ?? "";
    final savedPassword = prefs.getString('password') ?? "";

    final enteredUser = _userController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    // ❌ Bloquear si los campos están vacíos
    if (enteredUser.isEmpty || enteredPassword.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, ingresa usuario y contraseña.";
      });
      return;
    }

    // ✅ Permitir acceso inmediato a admin
    if (enteredUser == "admin" && enteredPassword == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
      return;
    }

    // ✅ Validar usuario registrado en SharedPreferences
    if (enteredUser == savedUser && enteredPassword == savedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
      return;
    }

    // ❌ Usuario incorrecto
    setState(() {
      _errorMessage = "Usuario o contraseña incorrectos";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 🔥 Logo
              Center(
                child: Image.asset(
                  'assets/images/ninja_sdet_logo.png',
                  width: 250,
                  height: 250,
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 Título Neon
              const Center(
                child: NeonText('Ninja SDET⚡', fontSize: 48, italic: true),
              ),

              const SizedBox(height: 30),

              // 🔹 Campos de entrada
              TextField(
                key: const Key('user_field'),
                controller: _userController,
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              TextField(
                key: const Key('password_field'),
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    key: const Key('error_message'),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // 🔘 Botón de Ingreso
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key('login_button'),
                onPressed: _login,
                child: const Text('Ingresar'),
              ),

              const SizedBox(height: 10),

              // 🔹 Registro
              TextButton(
                key: const Key('register_button'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Registra tu usuario aquí', style: TextStyle(color: Colors.cyanAccent)),
              ),

              const SizedBox(height: 30),

              // 📌 Footer
              const FooterText(),
              // 📌 Versión de la App
              Text(
                _appVersion,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

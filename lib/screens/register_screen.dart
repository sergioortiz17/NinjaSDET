import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/neon_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isHuman = false;
  bool _acceptsTerms = false;
  bool _isButtonEnabled = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _passwordError;

  void _validateForm() {
    setState(() {
      bool passwordsMatch = _passwordController.text == _confirmPasswordController.text;
      _passwordError = passwordsMatch ? null : "Las contraseñas no coinciden";

      _isButtonEnabled = _userController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _isHuman &&
          _acceptsTerms &&
          passwordsMatch;
    });
  }

  void _register() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', _userController.text);
    await prefs.setString('password', _passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario creado con éxito'), backgroundColor: Colors.cyanAccent),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Volver al Login
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonText('Registro', fontSize: 22, italic: true)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NeonText("Usuario:", fontSize: 18),
            TextField(
              controller: _userController,
              onChanged: (_) => _validateForm(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            // 🔑 Campo de Contraseña con Ojito 👁
            const NeonText("Contraseña:", fontSize: 18),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              onChanged: (_) => _validateForm(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.cyanAccent),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔑 Campo de Confirmar Contraseña con Ojito 👁
            const NeonText("Confirmar Contraseña:", fontSize: 18),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              onChanged: (_) => _validateForm(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.cyanAccent),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: _isHuman,
                  onChanged: (value) {
                    setState(() {
                      _isHuman = value!;
                      _validateForm();
                    });
                  },
                ),
                const Text("¿Eres humano?", style: TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _acceptsTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptsTerms = value!;
                      _validateForm();
                    });
                  },
                ),
                const Text("¿Aceptas los TyC?", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _register : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? Colors.cyanAccent : Colors.grey,
                ),
                child: const Text("Crear user", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FeedbackScreen(),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int? selectedStars;
  List<String> options = ["Opción 1", "Opción 2", "Opción 3", "Opción 4"];
  List<String> selectedOptions = [];

  // Validar los campos
  void _validateForm() {
    if (_subjectController.text.isEmpty) {
      _showSnackbar("El asunto no puede estar vacío.");
      return;
    }
    if (_messageController.text.length < 5) {
      _showSnackbar("El mensaje debe tener al menos 5 caracteres.");
      return;
    }
    _showStarRatingModal(); // Muestra el modal de estrellas
  }

  // Mostrar Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.cyanAccent),
    );
  }

  // Modal para seleccionar estrellas ⭐⭐⭐⭐⭐
  void _showStarRatingModal() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const NeonText("Califica con estrellas", fontSize: 20, italic: true), // 🔥 NeonText
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: (selectedStars != null && selectedStars! > index)
                          ? Colors.cyanAccent
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setStateDialog(() {
                        selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (selectedStars == null) {
                      _showSnackbar("Selecciona al menos 1 estrella.");
                      return;
                    }
                    Navigator.pop(context);
                    _showSelectionModal();
                  },
                  child: const NeonText("Siguiente", fontSize: 16), // 🔥 NeonText
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Modal para seleccionar opciones con pills 🏷️
  void _showSelectionModal() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const NeonText("Selecciona opciones", fontSize: 20, italic: true), // 🔥 NeonText
              content: Wrap(
                spacing: 8.0,
                children: options.map((option) {
                  bool isSelected = selectedOptions.contains(option);
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setStateDialog(() {
                        if (selected) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                      });
                    },
                    selectedColor: Colors.cyanAccent.withOpacity(0.5),
                    backgroundColor: Colors.grey[800],
                    labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (selectedOptions.isEmpty) {
                      _showSnackbar("Selecciona al menos una opción.");
                      return;
                    }
                    Navigator.pop(context);
                    _showSuccessModal();
                  },
                  child: const NeonText("Listo", fontSize: 16), // 🔥 NeonText
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Modal final de éxito 🎉
  void _showSuccessModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const NeonText("¡Éxito!", fontSize: 22, italic: true), // 🔥 NeonText
          content: const NeonText("Gracias por tu feedback.", fontSize: 18), // 🔥 NeonText
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const NeonText("Cerrar", fontSize: 16), // 🔥 NeonText
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonText("Text Area & Modal Chain", fontSize: 22, italic: true)), // 🔥 NeonText en título
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NeonText("Asunto:", fontSize: 18), // 🔥 NeonText
            TextField(
              controller: _subjectController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            const NeonText("Mensaje:", fontSize: 18), // 🔥 NeonText
            TextField(
              controller: _messageController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                onPressed: _validateForm,
                child: const Text("Validar y continuar", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

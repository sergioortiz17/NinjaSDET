import 'package:flutter/material.dart';
import '../widgets/neon_text.dart';

class DropdownToggleScreen extends StatefulWidget {
  const DropdownToggleScreen({super.key});

  @override
  _DropdownToggleScreenState createState() => _DropdownToggleScreenState();
}

class _DropdownToggleScreenState extends State<DropdownToggleScreen> with SingleTickerProviderStateMixin {
  String _selectedDifficulty = 'Fácil'; // Opción por defecto en Dropdown
  double _progressValue = 0.3; // Valor inicial de la barra de progreso
  String? _selectedRadio; // Variable para Radio Buttons
  bool _clearSelection = false; // Toggle para limpiar radio buttons

  List<bool> _checkboxValues = [false, false, false]; // Lista de checkboxes
  bool _selectAll = false; // Toggle para seleccionar/deseleccionar todos

  late TabController _tabController; // Controlador de pestañas

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonText('Dropdown & Toggle', fontSize: 22, italic: true),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'RadioButtons'),
            Tab(text: 'Checkmarks'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NeonText('Selecciona la dificultad:', fontSize: 18),
            const SizedBox(height: 10),

            // 🔹 Dropdown para seleccionar la dificultad
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.cyanAccent),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: _selectedDifficulty,
                dropdownColor: Colors.black,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
                isExpanded: true,
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 18),
                underline: Container(),
                items: ['Fácil', 'Normal', 'Extremo']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                    _updateProgress(); // Llama a la función que cambia la barra de progreso
                  });
                },
              ),
            ),

            const SizedBox(height: 20),
            const NeonText('Nivel:', fontSize: 18),

            // 🔹 Barra de progreso dinámica
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * _progressValue,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Pestañas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRadioOptionsTab(),
                  _buildCheckmarksTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Función que actualiza el progreso según la dificultad seleccionada
  void _updateProgress() {
    setState(() {
      if (_selectedDifficulty == 'Fácil') {
        _progressValue = 0.3; // 30% del ancho
      } else if (_selectedDifficulty == 'Normal') {
        _progressValue = 0.6; // 60% del ancho
      } else if (_selectedDifficulty == 'Extremo') {
        _progressValue = 1.0; // 100% del ancho
      }
    });
  }

  // 🔹 Pestaña de Opciones (Radio Buttons)
  Widget _buildRadioOptionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NeonText('Radio Buttons Test:', fontSize: 18),
        const SizedBox(height: 10),

        _buildRadioButton('Opción 1'),
        _buildRadioButton('Opción 2'),
        _buildRadioButton('Opción 3'),

        const SizedBox(height: 20),

        // 🔹 Toggle para limpiar la selección de radio buttons
        SwitchListTile(
          title: const NeonText('Inhabilitar RadioButtons', fontSize: 16),
          value: _clearSelection,
          onChanged: (bool value) {
            setState(() {
              _clearSelection = value;
              if (_clearSelection) {
                _selectedRadio = null; // Limpia la selección
              }
            });
          },
          activeColor: Colors.cyanAccent,
          inactiveTrackColor: Colors.grey.shade800,
        ),

        const SizedBox(height: 20),

        // 🔹 Botón de confirmación
        Center(
          child: ElevatedButton(
            onPressed: _selectedRadio == null ? null : _showSuccessModal,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedRadio == null ? Colors.grey : Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text('Confirmar selección'),
          ),
        ),
      ],
    );
  }

  // 🔹 Pestaña de Checkmarks
  Widget _buildCheckmarksTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Toggle para seleccionar/deseleccionar todos los checkmarks
        SwitchListTile(
          title: const NeonText('Seleccionar todas', fontSize: 16),
          value: _selectAll,
          onChanged: (bool value) {
            setState(() {
              _selectAll = value;
              for (int i = 0; i < _checkboxValues.length; i++) {
                _checkboxValues[i] = value;
              }
            });
          },
          activeColor: Colors.cyanAccent,
          inactiveTrackColor: Colors.grey.shade800,
        ),

        _buildCheckbox('Check 1', 0),
        _buildCheckbox('Check 2', 1),
        _buildCheckbox('Check 3', 2),
      ],
    );
  }

  // 🔹 Widget reutilizable para Radio Buttons
  Widget _buildRadioButton(String title) {
    return ListTile(
      title: NeonText(title, fontSize: 16),
      leading: Radio<String>(
        value: title,
        groupValue: _selectedRadio,
        activeColor: Colors.cyanAccent,
        onChanged: _clearSelection
            ? null
            : (String? value) {
                setState(() {
                  _selectedRadio = value;
                });
              },
      ),
    );
  }

  // 🔹 Widget reutilizable para Checkboxes
  Widget _buildCheckbox(String title, int index) {
    return CheckboxListTile(
      title: NeonText(title, fontSize: 16),
      value: _checkboxValues[index],
      onChanged: (bool? value) {
        setState(() {
          _checkboxValues[index] = value!;
          _selectAll = _checkboxValues.every((element) => element);
        });
      },
      activeColor: Colors.cyanAccent,
      checkColor: Colors.black,
    );
  }

  // 🔹 Función para mostrar el modal de éxito
  void _showSuccessModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const NeonText('¡Éxito!', fontSize: 22),
          content: NeonText('Has seleccionado: $_selectedRadio', fontSize: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
            ),
          ],
        );
      },
    );
  }
}

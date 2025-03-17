import 'package:flutter/material.dart';
import '../widgets/neon_text.dart'; // 🔥 Importamos NeonText

class ChatNightmareScreen extends StatefulWidget {
  const ChatNightmareScreen({super.key});

  @override
  _ChatNightmareScreenState createState() => _ChatNightmareScreenState();
}

class _ChatNightmareScreenState extends State<ChatNightmareScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'bot', 'text': "Hola, ¿cómo estás? ¿Quieres que te cuente el cuento de la buena pipa?"}
  ];

  void _sendMessage() {
    String userMessage = _messageController.text.trim();

    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});

      if (userMessage.toLowerCase() == "dios salvame de esto") {
        _messages.add({'sender': 'bot', 'text': "🙏 Dios te ha escuchado hermano"});
      } else {
        _messages.add({'sender': 'bot', 'text': "No digas '$userMessage'!!, te pregunto si quieres que te cuente el cuento de la buena pipa?"});
      }
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonText('ChatBot', fontSize: 22, italic: true), // 🔥 NeonText aplicado solo en "ChatBot"
      ),
      body: Column(
        children: [
          // 📝 Área de mensajes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: isUser ? Colors.blueAccent.withOpacity(0.6) : Colors.redAccent.withOpacity(0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      message['text']!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // ✏️ Campo de entrada
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

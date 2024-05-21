import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  Future<void> sendMessage(String message) async {
    _messages.add({'role': 'user', 'content': message});
    notifyListeners();

    try {
      final response = await _chatService.sendMessage(message);
      _messages.add({'role': 'bot', 'content': response['message']});
    } catch (e) {
      _messages.add({'role': 'error', 'content': e.toString()});
    }

    notifyListeners();
  }
}

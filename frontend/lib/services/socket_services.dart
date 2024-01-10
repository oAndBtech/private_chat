import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:private_chat/models/msg_model_sender.dart';
import 'package:web_socket_client/web_socket_client.dart';

class SocketService {
  String url = "ws://${dotenv.env['IpV4']!}:${dotenv.env['port']!}/ws";

  buildSocketConnection(String roomId, int userId) {
    String finalWsUrl = "$url?roomId=$roomId&userId=$userId";
    Uri uri = Uri.parse(finalWsUrl);
    final socket = WebSocket(uri);
    return socket;
  }

  sendMessage(MessageModelSender msg, WebSocket? socket) {
    if (socket == null) return;
    final jsonContent = jsonEncode({
      'content': msg.content,
      'istext': msg.istext,
    });
    socket.send(jsonContent);
  }

  closeConnection(WebSocket socket) {
    socket.close();
  }
}

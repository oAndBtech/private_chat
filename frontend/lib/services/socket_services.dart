import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_client/web_socket_client.dart';

class SocketService {
  String url = "ws://${dotenv.env["backend"]!}/ws";

  buildSocketConnection(String roomId, int userId) {
    String finalWsUrl = "$url?roomId=$roomId&userId=$userId";
    Uri uri = Uri.parse(finalWsUrl);
    final socket = WebSocket(uri);
    return socket;
  }

  sendMessage(String msg, WebSocket? socket, bool isText) {
    if (socket == null) return;
    final jsonContent = jsonEncode({
      'content': msg,
      'istext': isText,
    });
    socket.send(jsonContent);
  }


  closeConnection(WebSocket socket) {
    socket.close();
  }
}

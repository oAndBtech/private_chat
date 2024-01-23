import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_client/web_socket_client.dart';

class SocketService {
  String url = "wss://${dotenv.env["backend"]!}/ws";

  buildSocketConnection(String roomId, int userId) {
    String finalWsUrl = "$url?roomId=$roomId&userId=$userId";
    Uri uri = Uri.parse(finalWsUrl);
    final socket = WebSocket(uri);
    return socket;
  }

  sendMessage(String msg, WebSocket? socket, bool isText, String uniqueid,
      String? replyto) {
    if (socket == null) return;
    print(uniqueid);
    final jsonContent = jsonEncode({
      'content': msg,
      'istext': isText,
      'uniqueId': uniqueid,
      'replyto': replyto
    });
    socket.send(jsonContent);
  }

  closeConnection(WebSocket socket) {
    socket.close();
  }
}

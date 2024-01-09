import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/message_model.dart';

final messageProvider =
    StateNotifierProvider<MessageNotifier, List<MessageModel>>(
        (ref) => MessageNotifier());

class MessageNotifier extends StateNotifier<List<MessageModel>> {
  MessageNotifier() : super([]);

  void addMessage(MessageModel msg) {
    state = [...state, msg];
  }

  void addAllMessages(List<MessageModel> msgs) {
    state = [...state, ...msgs];
  }

  void deleteMessages(MessageModel msg) {
    state = state.where((element) => element != msg).toList();
  }

  void deleteAllMessages() {
    state = [];
  }
}

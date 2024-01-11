import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/room_model.dart';

final roomIdProvider = StateProvider<String?>((ref) => null);
final roomProvider =
    StateNotifierProvider<RoomNotifier, RoomModel?>((ref) => RoomNotifier());

class RoomNotifier extends StateNotifier<RoomModel?> {
  RoomNotifier() : super(null);

  void addRoom(RoomModel room) {
    state = room;
  }

  void clearState() {
    state = null;
  }
}

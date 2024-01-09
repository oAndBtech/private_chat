import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomProvider =
    StateNotifierProvider<RoomNotifier, String?>((ref) => RoomNotifier());

class RoomNotifier extends StateNotifier<String?> {
  RoomNotifier() : super(null);

  void addRoom(String roomId) {
    state = roomId;
  }

  void clearState() {
    state = null;
  }
}

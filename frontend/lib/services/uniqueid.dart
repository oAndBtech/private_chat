class UniqueIdService {
  //FORMAT : oandbtech@date-senderId-roomId@oandbtech
  String generateUniqueId(int senderId, String roomId) {
    String date = DateTime.now().toUtc().toIso8601String().toString();
    return "oandbtech@$date-$senderId-$roomId@oandbtech";
  }
}

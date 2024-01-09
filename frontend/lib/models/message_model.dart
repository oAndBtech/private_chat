class MessageModel {
  final int? id;
  final int sender;
  final String receiver;
  final bool istext;
  final String? timestamp;
  final List<int> content; 

  MessageModel({
    this.id,
    required this.sender,
    required this.receiver,
    required this.istext,
    this.timestamp,
    required this.content,
  });
}

class MessageModelSender {
  final int? id;
  final int? sender;
  final String? receiver;
  final bool istext;
  final String? timestamp;
  final String content;
  final String? sendername;

  MessageModelSender({
    required this.content,
    required this.istext,
    this.id,
    this.sender,
    this.receiver,
    this.timestamp,
    this.sendername,
  });
}

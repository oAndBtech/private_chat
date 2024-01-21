class MessageModel {
  final int? id;
  final int? sender;
  final String? receiver;
  final bool istext;
  final String? timestamp;
  final List<int> content; 
  final String? sendername;
  final bool? isOffline;
  final String uniqueid;
  final String? replyto;

  MessageModel({
    this.id,
    this.sender,
    this.receiver,
    required this.istext,
    this.timestamp,
    required this.content,
    this.sendername,
    this.isOffline,
    this.replyto,
    required this.uniqueid
  });
}

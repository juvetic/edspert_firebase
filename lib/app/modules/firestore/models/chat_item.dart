class ChatItem {
  final String content;
  final int id;
  final String name;
  String? image;
  bool? isSender;
  final bool isTutor;
  final DateTime dateTime;

  ChatItem({
    this.image,
    required this.content,
    required this.id,
    required this.name,
    this.isSender = false,
    this.isTutor = false,
    required this.dateTime,
  });
}

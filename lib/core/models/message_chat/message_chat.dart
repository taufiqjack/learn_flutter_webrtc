class MessageChat {
  int? id;
  String? chat;

  MessageChat({this.id, this.chat});

  factory MessageChat.fromJson(Map<String, dynamic> json) => MessageChat(
        id: json['id'] as int?,
        chat: json['chat'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chat': chat,
      };
}

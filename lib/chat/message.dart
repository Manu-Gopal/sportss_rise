class Message {
  Message({
    required this.id,
    required this.profile_id,
    required this.content,
    required this.createdAt,
    required this.isMine,
    // required this.userTo,
  });

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String profile_id;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  /// Whether the message is sent by the user or not.
  final bool isMine;
  // final String userTo;

  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        profile_id = map['profile_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        isMine = myUserId == map['profile_id'];
        // userTo = map['user_to'];
}

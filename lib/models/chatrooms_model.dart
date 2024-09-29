class ChatroomsModel {
  final String lastMessage, lastUpdates;
  final List<String> participants;

  ChatroomsModel({
    required this.lastMessage,
    required this.lastUpdates,
    required this.participants,
  });
}

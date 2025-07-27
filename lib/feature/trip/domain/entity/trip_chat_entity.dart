class ChatMessageEntity {
  final String id;
  final String tripId;
  final String sender; // 'user' or 'ai'
  final String prompt;
  final String message;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.prompt,
    required this.id,
    required this.tripId,
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}

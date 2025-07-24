import 'package:isar/isar.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
part 'trip_chat_model.g.dart'; // ✅ Required for Isar codegen

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.tripId,
    required super.sender,
    required super.prompt,
    required super.message,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      tripId: json['tripId'],
      sender: json['sender'],
      prompt: json['prompt'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'sender': sender,
      'prompt': prompt,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      tripId: entity.tripId,
      sender: entity.sender,
      prompt: entity.prompt,
      message: entity.message,
      timestamp: entity.timestamp,
    );
  }
}

@collection
class TripChatModel {
  Id id = Isar.autoIncrement;

  late String tripId;
  late String sender; // 'user' or 'ai'
  late String prompt;
  late String message;
  late DateTime timestamp;

  TripChatModel();

  // Convert from entity
  TripChatModel.fromEntity(ChatMessageEntity entity) {
    tripId = entity.tripId;
    sender = entity.sender;
    prompt = entity.prompt;
    message = entity.message;
    timestamp = entity.timestamp;
  }

  // Convert to entity
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id.toString(),
      tripId: tripId,
      sender: sender,
      prompt: prompt,
      message: message,
      timestamp: timestamp,
    );
  }
}

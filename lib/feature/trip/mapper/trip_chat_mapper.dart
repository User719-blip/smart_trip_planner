// mappers/trip_chat_mapper.dart



import 'package:smart_trip_planner/feature/trip/data/models/trip_chat_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';

extension TripChatModelMapper on TripChatModel {
  ChatMessageEntity toEntity() => ChatMessageEntity(
        id: id,
        tripId: tripId,
        sender: sender,
        prompt: prompt,
        message: message,
        timestamp: timestamp,
      );
}

extension TripChatEntityMapper on ChatMessageEntity {
  TripChatModel toModel() => TripChatModel.create(
        tripId: tripId,
        sender: sender,
        prompt: prompt,
        message: message,
        timestamp: timestamp,
      );
}

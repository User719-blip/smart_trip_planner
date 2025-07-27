import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';

class SaveChatMessage {
  final TripRepository repo;
  SaveChatMessage(this.repo);

  Future<void> call(ChatMessageEntity message) => repo.saveMessage(message);
}

class StreamTripChat {
  final TripRepository repo;
  StreamTripChat(this.repo);

  Stream<List<ChatMessageEntity>> call(String tripId) => repo.watchTripChats(tripId);
}

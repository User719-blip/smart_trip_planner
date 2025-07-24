import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';



abstract class TripRepository {
  Stream<String> streamTripPlan(String prompt); // for streaming UI
  Future<ChatMessageEntity> generateFullTripPlan(String prompt); // fallback full response
  Future<void> saveTripChat(ChatMessageEntity chat);
  Stream<List<ChatMessageEntity>> getChatHistory();
}

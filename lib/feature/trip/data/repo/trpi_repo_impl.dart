import 'dart:convert';

import 'package:smart_ai_trip_planner/feature/trip/data/datasources/trip_remote_datasource.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/repo/trip_repo.dart';

class GeminiTripRepository implements TripRepository {
  final GeminiTripDatasource datasource;

  GeminiTripRepository(this.datasource);

  @override
  Stream<String> streamTripPlan(String prompt) {
    return datasource.streamTripPlan(prompt);
  }

  @override
  Future<ChatMessageEntity> generateFullTripPlan(String prompt) async {
    final plan = await datasource.generateTripPlan(prompt);
    return ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tripId: plan.title,
      sender: 'ai',
      prompt: prompt,
      message: jsonEncode(plan),
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<void> saveTripChat(ChatMessageEntity chat) async {
    // Save to local storage (Isar or similar) - implement later
  }

  @override
  Stream<List<ChatMessageEntity>> getChatHistory() {
    // Return local chat history - implement later
    return const Stream.empty();
  }
}

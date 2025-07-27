import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:smart_trip_planner/feature/trip/data/datasources/trip_remote_datasource.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_chat_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';
import 'package:smart_trip_planner/feature/trip/mapper/trip_chat_mapper.dart';
class GeminiTripRepository implements TripRepository {
  final GeminiTripDatasource datasource;
  final isar = Isar.getInstance();
  
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

  final chatModel = TripChatModel.fromEntity(chat);
  await isar?.writeTxn(() async {
    await isar!.tripChatModels.put(chatModel);
  });
}
  @override
  Stream<List<ChatMessageEntity>> getChatHistory() {
    // Return local chat history - implement later
    return const Stream.empty();
  }
  
@override
Future<void> saveMessage(ChatMessageEntity message) async {
  final chatModel = message.toModel();
  await isar!.writeTxn(() async {
    await isar?.tripChatModels.put(chatModel);
  });
}

@override
Stream<List<ChatMessageEntity>> watchTripChats(String tripId) {
  return isar!.tripChatModels
      .filter()
      .tripIdEqualTo(tripId)
      .sortByTimestampDesc()
      .watch(fireImmediately: true)
      .map((models) => models.map((m) => m.toEntity()).toList());
}

  @override
Future<void> deleteTripChat(String id) async {
  await isar?.writeTxn(() async {
    await isar?.tripChatModels.delete(int.parse(id));
  });
}

}

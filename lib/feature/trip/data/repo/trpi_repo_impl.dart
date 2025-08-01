import 'dart:convert';

import 'package:smart_trip_planner/feature/trip/data/datasources/trip_local_datasource.dart';
import 'package:smart_trip_planner/feature/trip/data/datasources/trip_remote_datasource.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_chat_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';
import 'package:smart_trip_planner/feature/trip/mapper/trip_chat_mapper.dart';

class GeminiTripRepository implements TripRepository {
  final GeminiTripDatasource datasource;
  final TripLocalDatasource localDatasource;
  
  GeminiTripRepository(this.datasource, this.localDatasource);

  @override
  Future<void> saveTripChat(ChatMessageEntity chat) async {
    final chatModel = TripChatModel.fromEntity(chat);
    await localDatasource.saveChatMessage(chatModel);
  }

  @override
  Future<void> saveMessage(ChatMessageEntity message) async {
    final chatModel = message.toModel();
    await localDatasource.saveChatMessage(chatModel);
  }

  @override
  Stream<List<ChatMessageEntity>> watchTripChats(String tripId) {
    return localDatasource.getMessagesByTripId(tripId);
  }

  @override
  Stream<List<ChatMessageEntity>> getChatHistory() {
    return localDatasource.getAllMessages();
  }

  @override
  Future<void> deleteTripChat(int id) async {
    final isar = await localDatasource.database;
    await isar.writeTxn(() async {
      await isar.tripChatModels.delete(id);
    });
  }
  
   @override
  Future<ChatMessageEntity> generateFullTripPlan(String prompt) async {
    try {
      // Generate trip plan using the remote datasource
      final tripPlan = await datasource.generateTripPlan(prompt);
      
      // Create a ChatMessageEntity from the generated plan
      final chatMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        tripId: tripPlan.title, // Use trip title as tripId
        sender: 'ai',
        prompt: prompt,
        message: jsonEncode(tripPlan.toJson()), // Convert trip plan to JSON string
        timestamp: DateTime.now(),
      );
      
      // Save the generated message to local database
      await saveMessage(chatMessage);
      
      return chatMessage;
    } catch (e) {
      // Re-throw the exception to be handled by the caller
      rethrow;
    }
  }
  
  @override
  Stream<String> streamTripPlan(String prompt) {
    // Use the streaming method from the remote datasource
    return datasource.streamTripPlan(prompt);
  }
}
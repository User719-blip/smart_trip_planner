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
  Future<ChatMessageEntity> generateFullTripPlan(String prompt) {
    // TODO: implement generateFullTripPlan
    throw UnimplementedError();
  }
  
  @override
  Stream<String> streamTripPlan(String prompt) {
    // TODO: implement streamTripPlan
    throw UnimplementedError();
  }
}
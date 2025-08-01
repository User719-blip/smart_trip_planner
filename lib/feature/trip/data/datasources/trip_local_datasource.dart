import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_chat_model.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_local_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';

class TripLocalDatasource {
  late Future<Isar> _db;

  TripLocalDatasource() {
    _db = _initIsar();
  }

  Future<Isar> get database => _db; // added a public getter

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([
      TripPlanLocalModelSchema,
      TripChatModelSchema,
    ], directory: dir.path);
  }

  Future<void> saveTrip(TripPlanLocalModel trip) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.tripPlanLocalModels.put(trip);
    });
  }

  Stream<List<ChatMessageEntity>> getAllMessages() async* {
    final isar = await _db;

    yield* isar.tripChatModels
        .where()
        .sortByTimestampDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  Future<void> saveChatMessage(TripChatModel chatModel) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.tripChatModels.put(chatModel);
    });
  }

  Stream<List<ChatMessageEntity>> getMessagesByTripId(String tripId) async* {
    final isar = await _db;
    yield* isar.tripChatModels
        .filter()
        .tripIdEqualTo(tripId)
        .sortByTimestampDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
  
  Future<List<TripPlanLocalModel>> getSavedTrips() async {
    final isar = await _db;
    return await isar.tripPlanLocalModels.where().findAll();
  }

  Future<void> deleteTrip(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.tripPlanLocalModels.delete(id);
    });
  }
}

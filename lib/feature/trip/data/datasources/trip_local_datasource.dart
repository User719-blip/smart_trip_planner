import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_local_model.dart';

class TripLocalDatasource {
  late Future<Isar> _db;

  TripLocalDatasource() {
    _db = _initIsar();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [TripPlanLocalModelSchema],
      directory: dir.path,
    );
  }

  Future<void> saveTrip(TripPlanLocalModel trip) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.tripPlanLocalModels.put(trip);
    });
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

import 'package:smart_trip_planner/feature/trip/data/datasources/trip_local_datasource.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_local_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';

class SaveTripChat {
  final TripRepository repository;

  SaveTripChat(this.repository);

  Future<void> call(ChatMessageEntity chat) {
    return repository.saveTripChat(chat);
  }
}

class SaveTripOffline {
  final TripLocalDatasource datasource;

  SaveTripOffline(this.datasource);

  Future<void> call(TripPlanLocalModel trip) => datasource.saveTrip(trip);
}

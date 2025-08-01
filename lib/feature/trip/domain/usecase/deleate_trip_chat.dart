import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';

class DeleteTripMessage {
  final TripRepository repo;

  DeleteTripMessage(this.repo);

  Future<void> call(int id) => repo.deleteTripChat(id);
}

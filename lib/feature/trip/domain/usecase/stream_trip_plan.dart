
import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';



class StreamTripPlan {
  final TripRepository repository;

  StreamTripPlan(this.repository);

  Stream<String> call(String prompt) {
    return repository.streamTripPlan(prompt);
  }
}

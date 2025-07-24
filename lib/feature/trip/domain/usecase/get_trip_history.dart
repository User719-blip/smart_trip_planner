
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/domain/repo/trip_repo.dart';

class GetTripHistory {
  final TripRepository repository;

  GetTripHistory(this.repository);

  Stream<List<ChatMessageEntity>> call() {
    return repository.getChatHistory();
  }
}

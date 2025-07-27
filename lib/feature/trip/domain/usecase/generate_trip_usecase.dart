import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/repo/trip_repo.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_ai_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';

final generateTripUseCaseProvider = Provider<GenerateTripUseCase>((ref) {
  final repo = ref.watch(tripRepositoryProvider);
  return GenerateTripUseCase(repo);
});

class GenerateTripUseCase {
  final TripRepository repository;
  GenerateTripUseCase(this.repository);

  Future<ChatMessageEntity> call(String prompt) {
    return repository.generateFullTripPlan(prompt);
  }
}

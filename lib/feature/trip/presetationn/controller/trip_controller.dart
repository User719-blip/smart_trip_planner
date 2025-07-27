import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ai_trip_planner/feature/trip/data/datasources/trip_local_datasource.dart';
import 'package:smart_ai_trip_planner/feature/trip/data/datasources/trip_remote_datasource.dart';
import 'package:smart_ai_trip_planner/feature/trip/data/repo/trpi_repo_impl.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/repo/trip_repo.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/usecase/generate_trip_usecase.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/usecase/save_trip_history.dart';

final tripControllerProvider = StateNotifierProvider<TripController, AsyncValue<ChatMessageEntity?>>((ref) {
  final generateTripUseCase = ref.watch(generateTripUseCaseProvider);
  return TripController(generateTripUsecase: generateTripUseCase);
});

final saveTripOfflineProvider = Provider<SaveTripOffline>((ref) {
  return SaveTripOffline(TripLocalDatasource());
});

 
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return GeminiTripRepository(GeminiTripDatasource());
});

class TripController extends StateNotifier<AsyncValue<ChatMessageEntity?>> {
  final GenerateTripUseCase generateTripUsecase;

  
  TripController({required this.generateTripUsecase}) : super(const AsyncValue.data(null));

  Future<ChatMessageEntity> generateTrip(String prompt) async {
    state = const AsyncValue.loading();
    try {
      final result = await generateTripUsecase(prompt);
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_ai_trip_planner/feature/trip/domain/usecase/get_trip_history.dart';

final getTripHistoryProvider = Provider<GetTripHistory>((ref) {
  // Replace this with actual repo instance later
  throw UnimplementedError();
});

class SavedItinerariesList extends ConsumerWidget {
  const SavedItinerariesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripStream = ref.watch(getTripHistoryProvider).call();

    return StreamBuilder<List<ChatMessageEntity>>(
      stream: tripStream,
      builder: (context, snapshot) {
        final trips = snapshot.data ?? [];
        if (trips.isEmpty) {
          return const Center(child: Text("No trips saved yet."));
        }

        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final chat = trips[index];
            return ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(chat.prompt, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () {
                // TODO: Navigate to itinerary details
              },
            );
          },
        );
      },
    );
  }
}

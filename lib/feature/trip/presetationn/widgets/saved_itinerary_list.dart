import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/domain/usecase/get_trip_history.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/pages/trip_follow_up_page.dart';

final getTripHistoryProvider = Provider<GetTripHistory>((ref) {
  final repo = ref.watch(tripRepositoryProvider); // <-- Your implemented repo
  return GetTripHistory(repo);
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

            return Dismissible(
              key: Key(chat.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete this itinerary?"),
                        content: const Text("This action cannot be undone."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    ) ??
                    false;
              },
              onDismissed: (_) async {
                await ref.read(deleteTripProvider).call(chat.id);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Trip deleted")));
              },
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  chat.prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TripFollowUpPage(trip: chat),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

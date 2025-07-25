import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/pages/trip_result_page.dart';

class TripLoadingPage extends ConsumerStatefulWidget {
  final String prompt;

  const TripLoadingPage({super.key, required this.prompt});

  @override
  ConsumerState<TripLoadingPage> createState() => _TripLoadingPageState();
}

class _TripLoadingPageState extends ConsumerState<TripLoadingPage> {
  @override
  void initState() {
    super.initState();
    _generateItinerary();
  }

  Future<void> _generateItinerary() async {
    try {
      final ChatMessageEntity trip = await ref
          .read(tripControllerProvider.notifier)
          .generateTrip(widget.prompt);
      // Navigate to result page on success
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => TripResultPage(trip: trip)),
        );
      }
    } catch (e) {
      // Show error and go back
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to generate trip: $e")));
        Navigator.of(context).pop(); // Return to previous page
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.prompt),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(child: Icon(Icons.add_photo_alternate)),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "Generating your itinerary...",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Sit tight while we plan your perfect trip!",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.subtitle),
            ),
          ],
        ),
      ),
    );
  }
}

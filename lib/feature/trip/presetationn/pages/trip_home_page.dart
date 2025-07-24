// trip_home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/create_itinerary_button.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/prompt_input.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/saved_itinerary_list.dart';

class TripHomePage extends ConsumerWidget {
  const TripHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final name = user?.name ?? 'Traveler';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(name),
              const SizedBox(height: 20),
              const PromptInput(),
              const SizedBox(height: 16),
              const CreateItineraryButton(),
              const SizedBox(height: 24),
              const Text(
                "Offline Saved Itineraries",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Expanded(child: SavedItinerariesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Hey $name 👋",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            )),
        const CircleAvatar(
          child: Text("S"), // Placeholder, update to profile image later
        )
      ],
    );
  }
}

// trip_home_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trip_planner/feature/profile/presentation/pages/profile_page.dart';
import 'package:smart_trip_planner/feature/profile/presentation/providers/profile_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/create_itinerary_button.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/prompt_input.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/saved_itinerary_list.dart';

class TripHomePage extends ConsumerWidget {
  const TripHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final user = ref.watch(authControllerProvider).value;
    final profile = ref.watch(profileControllerProvider);
    final name = profile.name?.trim().isNotEmpty == true ? profile.name! : 'Traveler';


    final promptController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context , name),
              const SizedBox(height: 20),
              PromptInput(promptController: promptController),
              const SizedBox(height: 16),
              CreateItineraryButton(promptController: promptController),
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

  Widget _buildHeader(BuildContext context , String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Hey $name 👋",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
          },
          child: Consumer(
            builder: (context, ref, _) {
              final profile = ref.watch(profileControllerProvider);
              if (profile.imagePath != null) {
                return CircleAvatar(
                  backgroundImage: FileImage(File(profile.imagePath!)),
                );
              } else {
                return const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text("S", style: TextStyle(color: Colors.white)),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

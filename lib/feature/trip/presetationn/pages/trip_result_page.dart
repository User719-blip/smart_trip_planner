// trip_result_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/profile/presentation/pages/profile_page.dart';
import 'package:smart_trip_planner/feature/profile/presentation/providers/profile_controller.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_local_model.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/pages/trip_follow_up_page.dart';

class TripResultPage extends ConsumerStatefulWidget {
  final ChatMessageEntity trip;

  const TripResultPage({super.key, required this.trip});

  @override
  ConsumerState<TripResultPage> createState() => _TripResultPageState();
}

class _TripResultPageState extends ConsumerState<TripResultPage> {
  late ChatMessageEntity currentTrip;

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
  }

  // Future<void> _regenerateTrip() async {
  //   final result = await ref
  //       .read(tripControllerProvider.notifier)
  //       .generateTrip(currentTrip.prompt);

  //   if (mounted) {
  //     setState(() {
  //       currentTrip = result;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final state = ref.watch(tripControllerProvider);

    final parsedPlan = TripPlanModel.fromJson(jsonDecode(currentTrip.message));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Itinerary Created 🌴"),
        leading: BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Itinerary details card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView(
                  children: [
                    for (var i = 0; i < parsedPlan.days.length; i++) ...[
                      Text(
                        "Day ${i + 1}: ${parsedPlan.days[i].summary}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...parsedPlan.days[i].items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "• ${item.time}: ${item.activity} at ${item.location}",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const Divider(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TripFollowUpPage(
                          trip: currentTrip,
                        ), //add this in there
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Follow up to refine"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    final localTrip = TripPlanLocalModel.create(
                      title: parsedPlan.title,
                      startDate: parsedPlan.startDate,
                      endDate: parsedPlan.endDate,
                      days: parsedPlan.days
                          .map(
                            (day) => TripDayLocalModel.create(
                              date: day.date,
                              summary: day.summary,
                              items: day.items
                                  .map(
                                    (item) => TripItemLocalModel.create(
                                      time: item.time,
                                      activity: item.activity,
                                      location: item.location,
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                          .toList(),
                    );

                    ref.read(saveTripOfflineProvider).call(localTrip);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Trip saved offline!")),
                    );
                  },
                  icon: const Icon(Icons.download_for_offline),
                  label: const Text("Save Offline"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_local_model.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/ai_massage_card.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/user_massege_card.dart';

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

  Future<void> _regenerateTrip() async {
    final result = await ref
        .read(tripControllerProvider.notifier)
        .generateTrip(currentTrip.prompt);

    if (mounted) {
      setState(() {
        currentTrip = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          currentTrip.prompt.split(" ").take(4).join(" "),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            UserMessageCard(message: currentTrip.prompt),
            const SizedBox(height: 12),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              AIMessageCard(
                IconButton(
                  icon: const Icon(Icons.download_for_offline),
                  onPressed: () {
                    final parsedPlan = TripPlanModel.fromJson(
                      jsonDecode(currentTrip.message),
                    );

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
                ),
                message: currentTrip.message,
                prompt: currentTrip.prompt,
                onRegenerate: _regenerateTrip,
              ),
          ],
        ),
      ),
    );
  }
}

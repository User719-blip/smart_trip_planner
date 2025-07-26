import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_local_model.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_model.dart';
import 'package:smart_trip_planner/feature/trip/domain/entity/trip_chat_entity.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/ai_bubble_card.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/refine_input_bar.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/widgets/user_bubble_card.dart';

class TripFollowUpPage extends ConsumerStatefulWidget {
  final ChatMessageEntity trip;

  const TripFollowUpPage({super.key, required this.trip});

  @override
  ConsumerState<TripFollowUpPage> createState() => _TripFollowUpPageState();
}

class _TripFollowUpPageState extends ConsumerState<TripFollowUpPage> {
  final TextEditingController _controller = TextEditingController();
  late ChatMessageEntity currentTrip;

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Clear the input immediately
    _controller.clear();
    FocusScope.of(context).unfocus(); // Hide keyboard

    try {
      final newTrip = await ref
          .read(tripControllerProvider.notifier)
          .generateTrip(
            text,
          ); // You can use generateFollowUp() if you separate it

      setState(() {
        currentTrip = newTrip;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to refine: $e")));
    }
  }

  void _handleMic() {
    debugPrint("Mic tapped");
    // TODO: Implement voice input
  }

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: currentTrip.message));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  Future<void> _handleSaveOffline() async {
    try {
      final parsed = TripPlanModel.fromJson(jsonDecode(currentTrip.message));
      final localTrip = TripPlanLocalModel.create(
        title: parsed.title,
        startDate: parsed.startDate,
        endDate: parsed.endDate,
        days: parsed.days
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
      await ref.read(saveTripOfflineProvider).call(localTrip);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Trip saved offline!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save trip: $e")));
    }
  }

  Future<void> _handleRegenerate() async {
    try {
      final newTrip = await ref
          .read(tripControllerProvider.notifier)
          .generateTrip(currentTrip.prompt);

      setState(() {
        currentTrip = newTrip;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to regenerate: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedPlan = TripPlanModel.fromJson(jsonDecode(currentTrip.message));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          "${currentTrip.prompt.split(" ").take(4).join(" ")}...",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text("S", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                UserBubbleCard(prompt: currentTrip.prompt),
                const SizedBox(height: 12),
                AIBubbleCard(
                  title: parsedPlan.title,
                  message: currentTrip.message,
                  locationText: parsedPlan.days.first.items.first.location,
                  durationText:
                      "${parsedPlan.startDate} - ${parsedPlan.endDate}",
                  onCopy: _handleCopy,
                  onSaveOffline: _handleSaveOffline,
                  onRegenerate: _handleRegenerate,
                ),
              ],
            ),
          ),
          RefineInputBar(
            controller: _controller,
            onSend: _handleSend,
            onMic: _handleMic,
          ),
        ],
      ),
    );
  }
}

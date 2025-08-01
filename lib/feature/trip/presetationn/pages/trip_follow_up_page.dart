import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/profile/presentation/pages/profile_page.dart';
import 'package:smart_trip_planner/feature/profile/presentation/providers/profile_controller.dart';
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
    // Save the initial trip if not already saved
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(saveTripMessageProvider)(widget.trip);
    });
  }

  void _handleMic() {}

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    FocusScope.of(context).unfocus();

    // ✅ Save user message first
    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      tripId: widget.trip.tripId,
      sender: 'user',
      prompt: text,
      message: text,
      timestamp: DateTime.now(),
    );

    await ref.read(saveTripMessageProvider)(userMessage);

    try {
      final newTrip = await ref
          .read(tripControllerProvider.notifier)
          .generateTrip(text);

      setState(() {
        currentTrip = newTrip;
      });

      await ref.read(saveTripMessageProvider)(newTrip);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to refine: $e")));
    }
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

      await ref.read(saveTripMessageProvider)(newTrip);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to regenerate: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripId = widget.trip.tripId;
    final chatStream = ref.watch(watchTripChatsProvider(tripId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          "${widget.trip.prompt.split(" ").take(4).join(" ")}...",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
      body: Column(
        children: [
          Expanded(
            child: chatStream.when(
              data: (messages) {
                final fullChat = [...messages, currentTrip];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: fullChat.length,
                  itemBuilder: (context, index) {
                    final message = fullChat[index];
                    final isUser = message.sender == 'user';

                    if (isUser) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: UserBubbleCard(prompt: message.prompt),
                      );
                    } else {
                      // Try decoding JSON safely
                      TripPlanModel? parsed;
                      try {
                        parsed = TripPlanModel.fromJson(
                          jsonDecode(message.message),
                        );
                      } catch (e) {
                        debugPrint(
                          "⚠️ Failed to parse AI message JSON: $e\n${message.message}",
                        );
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "⚠️ Failed to parse trip plan.",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      // If parsed is still null, skip rendering
                      if (parsed == null) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AIBubbleCard(
                          title: parsed.title,
                          message: message.message,
                          locationText:
                              parsed.days.isNotEmpty &&
                                  parsed.days.first.items.isNotEmpty
                              ? parsed.days.first.items.first.location
                              : 'Location not available',
                          durationText:
                              "${parsed.startDate} - ${parsed.endDate}",
                          onCopy: _handleCopy,
                          onSaveOffline: _handleSaveOffline,
                          onRegenerate: _handleRegenerate,
                        ),
                      );
                    }
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
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

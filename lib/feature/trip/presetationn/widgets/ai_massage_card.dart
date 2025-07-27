import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ai_trip_planner/feature/trip/presetationn/controller/trip_controller.dart';

class AIMessageCard extends ConsumerWidget {
  final String message;
  final String prompt;
  final VoidCallback onRegenerate;

  const AIMessageCard(IconButton iconButton, {
    super.key,
    required this.message,
    required this.prompt,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripControllerProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(child: Icon(Icons.person)),
        const SizedBox(width: 10),
        Expanded(
          child: Card(
            color: Colors.green[50],
            elevation: 1,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.isLoading
                      ? const LinearProgressIndicator()
                      : Text(state.value?.message ?? message),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: message));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Copied")),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: onRegenerate,
                      ),
                      IconButton(
                        icon: const Icon(Icons.save_alt),
                        onPressed: () {
                          // TODO: Save to Isar
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

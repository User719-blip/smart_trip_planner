// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AIBubbleCard extends StatelessWidget {
  final String title;
  final String message;
  final String locationText;
  final String durationText;
  final VoidCallback onCopy;
  final VoidCallback onSaveOffline;
  final VoidCallback onRegenerate;

  const AIBubbleCard({
    super.key,
    required this.title,
    required this.message,
    required this.locationText,
    required this.durationText,
    required this.onCopy,
    required this.onSaveOffline,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.android, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pin_drop, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text("Open in maps", style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const Icon(Icons.open_in_new, size: 16, color: Colors.blue)
                  ],
                ),
                const SizedBox(height: 6),
                Text(locationText, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: onCopy,
                child: Row(
                  children: const [
                    Icon(Icons.copy, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Copy", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onSaveOffline,
                child: Row(
                  children: const [
                    Icon(Icons.download_for_offline, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Save Offline", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRegenerate,
                child: Row(
                  children: const [
                    Icon(Icons.refresh, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Regenerate", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

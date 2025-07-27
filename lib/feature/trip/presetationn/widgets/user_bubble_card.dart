import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserBubbleCard extends StatelessWidget {
  final String prompt;

  const UserBubbleCard({super.key, required this.prompt});

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
                backgroundColor: Colors.green,
                child: Text("S", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              const Text("You", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prompt,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => Clipboard.setData(ClipboardData(text: prompt)),
                child: Row(
                  children: const [
                    Icon(Icons.copy, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Copy", style: TextStyle(color: Colors.grey)),
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

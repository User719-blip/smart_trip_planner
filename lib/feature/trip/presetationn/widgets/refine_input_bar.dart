
import 'package:flutter/material.dart';

class RefineInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;

  const RefineInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMic,
  });

  @override  
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration.collapsed(
                hintText: "Follow up to refine",
              ),
            ),
          ),
          IconButton(
            onPressed: onMic,
            icon: const Icon(Icons.mic, color: Colors.grey),
          ),
          IconButton(
            onPressed: onSend,
            icon: const Icon(Icons.send, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

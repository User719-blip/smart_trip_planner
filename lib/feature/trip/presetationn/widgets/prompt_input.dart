import 'package:flutter/material.dart';

class PromptInput extends StatelessWidget {
  const PromptInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "7 days in Bali next April...",
        prefixIcon: const Icon(Icons.edit_note),
        suffixIcon: const Icon(Icons.mic),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

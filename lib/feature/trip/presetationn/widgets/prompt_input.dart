import 'package:flutter/material.dart';

class PromptInput extends StatelessWidget {
   final TextEditingController promptController ;
  const PromptInput({super.key, required this.promptController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: promptController,
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

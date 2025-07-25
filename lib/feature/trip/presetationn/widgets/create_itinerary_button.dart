import 'package:flutter/material.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/pages/trip_loading_page.dart';

class CreateItineraryButton extends StatelessWidget {
  const CreateItineraryButton({super.key, required this.promptController});
  final TextEditingController promptController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
         final prompt = promptController.text.trim();
          if (prompt.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter a prompt")),
            );
            return;
          }
         Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => TripLoadingPage(prompt: prompt,),
          ),
        );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "Create My Itinerary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

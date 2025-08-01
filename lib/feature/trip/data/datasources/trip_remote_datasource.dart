import 'dart:async';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:smart_trip_planner/feature/trip/data/models/trip_plan_model.dart';

class GeminiTripDatasource {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey:
        'AIzaSyC_SYX0OB2k7peiiRn7AMJt2nLG9OOmwt4', // store securely in production
  );

  Future<TripPlanModel> generateTripPlan(String prompt) async {
    final fullPrompt =
        "You are a helpful travel planner. Return a JSON trip itinerary like this:\n"
        """{
          "title": "Kyoto 5-Day Solo Trip",
          "startDate": "2025-04-10",
          "endDate": "2025-04-15",
          "days": [
            {
              "date": "2025-04-10",
              "summary": "Fushimi Inari & Gion",
              "items": [
                { "time": "09:00", "activity": "Climb Fushimi Inari Shrine", "location": "34.9671,135.7727" },
                { "time": "14:00", "activity": "Lunch at Nishiki Market", "location": "35.0047,135.7630" },
                { "time": "18:30", "activity": "Evening walk in Gion", "location": "35.0037,135.7788" }
              ]
            }
          ]
        }\n"""
        "Now plan the following trip:\n$prompt";

    final response = await model.generateContent([Content.text(fullPrompt)]);

    final jsonRaw = response.text?.trim();
    if (jsonRaw == null) throw Exception("Gemini returned null response");
    if (jsonRaw.toLowerCase().contains("need more information")) {
      throw Exception(
        "AI needs more info. Please be more specific in your prompt.",
      );
    }
    final cleaned = cleanJson(jsonRaw);
    final decoded = jsonDecode(cleaned);
    return TripPlanModel.fromJson(decoded);
  }

  String cleanJson(String input) {
    final startIndex = input.indexOf('{');
    final endIndex = input.lastIndexOf('}');
    if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
      throw FormatException('No valid JSON object found');
    }

    final jsonString = input.substring(startIndex, endIndex + 1);
    return jsonString;
  }

  // Optional: streaming token-by-token response
  Stream<String> streamTripPlan(String prompt) async* {
    final fullPrompt =
        "You are a helpful travel planner. Return a JSON itinerary.\nUser: $prompt";

    final response = model.generateContentStream([Content.text(fullPrompt)]);
    await for (final chunk in response) {
      yield chunk.text ?? '';
    }
  }
}

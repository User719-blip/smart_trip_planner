class TripPlanEntity {
  final String id;
  final String userId;
  final String title; // eg. "7 Days in Bali"
  final String prompt;
  final List<String> days; // or structured day objects
  final DateTime createdAt;

  TripPlanEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.prompt,
    required this.days,
    required this.createdAt,
  });
}

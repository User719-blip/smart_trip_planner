import 'package:isar/isar.dart';

part 'trip_plan_local_model.g.dart';

@collection
@collection
class TripPlanLocalModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String startDate;
  late String endDate;
  late List<TripDayLocalModel> days;

  TripPlanLocalModel(); // Keep default constructor for Isar

  TripPlanLocalModel.create({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });
}


@embedded
class TripDayLocalModel {
  late String date;
  late String summary;
  late List<TripItemLocalModel> items;

  TripDayLocalModel();

  TripDayLocalModel.create({
    required this.date,
    required this.summary,
    required this.items,
  });
}


@embedded
class TripItemLocalModel {
  late String time;
  late String activity;
  late String location;

  TripItemLocalModel();

  TripItemLocalModel.create({
    required this.time,
    required this.activity,
    required this.location,
  });
}


class TripPlanModel {
  final String title;
  final String startDate;
  final String endDate;
  final List<TripDay> days;

  TripPlanModel({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    return TripPlanModel(
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      days: List<TripDay>.from(json['days'].map((x) => TripDay.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'days': days.map((d) => d.toJson()).toList(),
    };
  }
}

class TripDay {
  final String date;
  final String summary;
  final List<TripItem> items;

  TripDay({
    required this.date,
    required this.summary,
    required this.items,
  });

  factory TripDay.fromJson(Map<String, dynamic> json) {
    return TripDay(
      date: json['date'],
      summary: json['summary'],
      items: List<TripItem>.from(json['items'].map((x) => TripItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'summary': summary,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class TripItem {
  final String time;
  final String activity;
  final String location;

  TripItem({
    required this.time,
    required this.activity,
    required this.location,
  });

  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      time: json['time'],
      activity: json['activity'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'activity': activity,
      'location': location,
    };
  }
}

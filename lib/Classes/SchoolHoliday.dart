class SchoolHoliday {
  late String name;
  late DateTime startDate;
  late DateTime endDate;
  late int daysLeft = startDate.difference(DateTime.now()).inDays;

  SchoolHoliday(
      {required this.name, required this.startDate, required this.endDate});

  factory SchoolHoliday.fromJson(Map<String, dynamic> json) {
    return SchoolHoliday(
      name: json['name'][0]['text'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

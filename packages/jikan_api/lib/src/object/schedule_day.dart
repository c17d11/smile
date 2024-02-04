enum JikanScheduleDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  unknown,
  other
}

extension ScheduleDayText on JikanScheduleDay {
  String get code => name;
  String get text => name[0].toUpperCase() + name.substring(1);
}

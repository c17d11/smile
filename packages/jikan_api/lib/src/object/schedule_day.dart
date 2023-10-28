abstract class ScheduleDay {
  String get code;
  String get text;
}

class ScheduleMonday implements ScheduleDay {
  @override
  String get code => 'monday';

  @override
  String get text => 'Monday';
}

class ScheduleTuesday implements ScheduleDay {
  @override
  String get code => 'tuesday';

  @override
  String get text => 'Tuesday';
}

class ScheduleWednesDay implements ScheduleDay {
  @override
  String get code => 'wednesday';

  @override
  String get text => 'Wednesday';
}

class ScheduleThursday implements ScheduleDay {
  @override
  String get code => 'thursday';

  @override
  String get text => 'Thursday';
}

class ScheduleFriday implements ScheduleDay {
  @override
  String get code => 'friday';

  @override
  String get text => 'Friday';
}

class ScheduleSaturday implements ScheduleDay {
  @override
  String get code => 'saturday';

  @override
  String get text => 'Saturday';
}

class ScheduleSunday implements ScheduleDay {
  @override
  String get code => 'sunday';

  @override
  String get text => 'Sunday';
}

class ScheduleUnknown implements ScheduleDay {
  @override
  String get code => 'unknown';

  @override
  String get text => 'Unknown';
}

class ScheduleOther implements ScheduleDay {
  @override
  String get code => 'other';

  @override
  String get text => 'Other';
}

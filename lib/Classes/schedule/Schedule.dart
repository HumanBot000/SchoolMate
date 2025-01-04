import 'package:school_mate/Classes/schedule/Subject.dart';

import 'ScheduleMetadata.dart';

class Schedule {
  final ScheduleMetadata metadata;
  final List<Subject>
      subjects; // All subjects the user has created, even those that aren't selected in the schedule
  Schedule(this.metadata, this.subjects);
}

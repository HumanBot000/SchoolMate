// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get abcWeeks => 'A/B/C Weeks';

  @override
  String get abWeeks => 'A/B Weeks';

  @override
  String get addHomeworkTooltip => 'Add a Homework';

  @override
  String get addLessonButton => 'Add Lesson';

  @override
  String get addLessonLabel => 'Add a new lesson';

  @override
  String get addSubjectTooltip => 'Add a Subject';

  @override
  String get appTitle => 'SchoolMate';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get aWeeks => 'A Weeks';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeColor => 'Change Color';

  @override
  String get changeLessonDurationPrompt =>
      'You can change this later for each individual lesson.';

  @override
  String get completedTab => 'Completed';

  @override
  String get configureLessonTitle => 'Configure a Lesson';

  @override
  String get configureScheduleSubtitle =>
      'Configure your schedule to start tracking your lessons.';

  @override
  String get configureTeacher => 'Configure a Teacher';

  @override
  String get confirm => 'Confirm';

  @override
  String get continueLabel => 'Continue';

  @override
  String get createSubjectTitle => 'Create a Subject';

  @override
  String get currentWeekPrompt => 'What type of week is the current one?';

  @override
  String get currentWeekTypeRequired =>
      'The current week type must be included in the number of weeks';

  @override
  String get customLabel => 'Custom';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get defaultScheduleSetupHeader =>
      'Before you can start using the schedule, we need to know some last details about your day.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteLessonTooltip => 'Delete this lesson';

  @override
  String get diverse => 'Diverse';

  @override
  String get edit => 'Edit';

  @override
  String get editSchedule => 'Edit Schedule';

  @override
  String get enjoyFreeTime => 'Enjoy your free time!';

  @override
  String get enterFormOfAddress => 'Enter the form of address';

  @override
  String get enterStartEndTimesPrompt =>
      'Please enter the maximum start and end times.\n You can change this later for each individual day. ';

  @override
  String get enterSubjectNameHint => 'Enter Subject Name';

  @override
  String get enterSubjectNameInstruction => 'Enter the name of the subject';

  @override
  String get enterTeacherName => 'Enter the teacher\'s name';

  @override
  String get errorEndTimeAfterStartTime => 'End time must be after start time!';

  @override
  String get errorLessonOverlaps =>
      'This lesson overlaps with another one!\nChange the length of the other lesson first!';

  @override
  String errorLoadingSettings(String error) {
    return 'Error loading user settings: $error';
  }

  @override
  String get errorSelectAtLeastOneWeek =>
      'Select at least one week type to add a lesson to!';

  @override
  String get errorSelectStartEndTimes =>
      'Select when this lesson starts and ends!';

  @override
  String get errorTimesWithinSchoolDay =>
      'Start and end times must be within the school day!';

  @override
  String get errorUnresolvedProblems => 'You haven\'t fixed all problems!';

  @override
  String get female => 'Female';

  @override
  String get fillAllRequiredFields => 'Please fill in all required fields';

  @override
  String get formOfAddress => 'Form of Address';

  @override
  String get gender => 'Gender';

  @override
  String get generalTab => 'General';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get goodMorning => 'Good morning';

  @override
  String holidayInDays(String holidayName, String days) {
    return '$holidayName: In $days days 📆';
  }

  @override
  String get homeTitle => 'Home';

  @override
  String get homeworkDeleted => 'This homework has been deleted!';

  @override
  String get homeworkRemindersSubtitle =>
      'Decide how often and when you want to get reminded about open homework';

  @override
  String get homeworkRemindersTitle => 'Homework Reminders';

  @override
  String get homeworkTitle => 'Homework';

  @override
  String get lastLessonAfterFirst =>
      'Your last lesson must end after your first lesson starts.';

  @override
  String lessonDurationInfo(String minutes) {
    return 'Each lesson is $minutes minutes long';
  }

  @override
  String get lessonDurationPrompt => 'How long are your lessons?';

  @override
  String get lessonEndPrompt => 'When does this lesson end?';

  @override
  String get lessonStartPrompt => 'When does this lesson start?';

  @override
  String get lessonTimesOverlap =>
      'The provided lesson times may not overlap each other';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmMessage => 'You will be logged out of your account.';

  @override
  String get male => 'Male';

  @override
  String get marksTitle => 'Marks';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String minutesValue(String minutes) {
    return '$minutes minutes';
  }

  @override
  String minutesValueShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get name => 'Name';

  @override
  String get noClassesToday => 'No Classes Today';

  @override
  String get noDataAvailable => 'No data available.';

  @override
  String get noHolidaysForLocation =>
      'No upcoming holidays found for your location.';

  @override
  String get noSubjectsCreated => 'You haven\'t created any subjects yet';

  @override
  String get noTeachersSetup => 'You haven\'t setup any teachers yet';

  @override
  String get notificationsTab => 'Notifications';

  @override
  String get noUpcomingHolidays => 'No upcoming holidays found.';

  @override
  String get noUserSettings => 'No user settings found.';

  @override
  String get openTab => 'Open';

  @override
  String get preLessonNotificationsSubtitle =>
      'Get notified before a lesson so you don\'t have to look up the location';

  @override
  String get preLessonNotificationsTitle => 'Pre-Lesson Notifications';

  @override
  String get profileTitle => 'Profile';

  @override
  String get requiredFields => '* Required fields';

  @override
  String get residenceSubtitle =>
      'Tell us where you live, so we can calculate the next school holidays.';

  @override
  String get residenceTitle => 'Residence';

  @override
  String get roomNumberLabel => 'Room Number';

  @override
  String get save => 'Save';

  @override
  String get scheduleChangeWeeksPrompt =>
      'Does your schedule change every x weeks?';

  @override
  String get scheduleCorruptionWarning =>
      'Please note, that this might corrupt your current schedule. We highly encourage you to clear all lessons.';

  @override
  String get scheduleSetup => 'Schedule Setup';

  @override
  String get scheduleSetupWarning =>
      'Before you can add lessons and homeworks, please give us some details about your day. You don\'t have to add in your exact schedule in order to use these features.';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get selectEndTime => 'Select end time';

  @override
  String get selectFromSchedule => 'Select from Schedule';

  @override
  String get selectLabel => 'Select';

  @override
  String get selectLessonDaysPrompt =>
      'Please select the days you have lessons.';

  @override
  String get selectStartTime => 'Select start time';

  @override
  String get selectTeacher => 'Select a teacher';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get subjectNameLabel => 'Subject Name';

  @override
  String get subjectValidationAlert =>
      'Please provide a valid name and teacher for this subject.';

  @override
  String get teacherLabel => 'Teacher';

  @override
  String get teacherValidationAlert =>
      'Please provide a valid name and form of address for this teacher.';

  @override
  String get update => 'Update';

  @override
  String get updatedScheduleSuccess => 'Updated Schedule Successfully!';

  @override
  String get updateLessonButton => 'Update Lesson';

  @override
  String get weekLabel => 'Week';

  @override
  String weekLabelWithLetter(String letter) {
    return '$letter Weeks';
  }

  @override
  String get welcomeGreeting => 'Ready for another productive day?';

  @override
  String get weWillCalculateWeeks =>
      'We will calculate the following weeks for you!';

  @override
  String get whichWeekToday => 'Which week is today?';
}

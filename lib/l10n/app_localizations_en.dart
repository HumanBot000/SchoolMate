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
  String get accountConflictMessageEmail =>
      'An account with this email is already registered.\n\nIf you originally registered with Google, please use \'Continue with Google\'. Otherwise, try to log in using your password.';

  @override
  String get accountConflictMessageGoogle =>
      'An account with this email already exists (registered with email and password).\n\nPlease sign in using your email and password instead.';

  @override
  String get accountConflictMessageProvider =>
      'This email is already linked to another login provider (such as Google).\n\nPlease log in using \'Continue with Google\'.';

  @override
  String get accountConflictTitle => 'Account Conflict';

  @override
  String get add => 'Add';

  @override
  String get addedHomeworkSuccessfully => 'Added Homework successfully!';

  @override
  String get addExamTypeTooltip => 'Add a new Exam Type';

  @override
  String get addHomeworkTooltip => 'Add a Homework';

  @override
  String get additionalNote => 'Additional Note';

  @override
  String get addLessonButton => 'Add Lesson';

  @override
  String get addLessonLabel => 'Add a new lesson';

  @override
  String get addMarkDetailsHint => 'Add details about this mark...';

  @override
  String get addMarkTooltip => 'Add a Mark to a subject';

  @override
  String get addSubjectTooltip => 'Add a Subject';

  @override
  String get appTitle => 'SchoolMate';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get aWeeks => 'A Weeks';

  @override
  String get backToPresentTooltip => 'Back to Present';

  @override
  String get baseExamTypeLabel => 'Base Exam Type';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeColor => 'Change Color';

  @override
  String get changeLessonDurationPrompt =>
      'You can change this later for each individual lesson.';

  @override
  String get checkConnectionAndTry =>
      'Please check your connection and try again.';

  @override
  String get chooseUsernameTitle => 'Choose a Username';

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
  String get connectionError => 'Connection Error';

  @override
  String get continueLabel => 'Continue';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get couldNotConnectToServers => 'We couldn\'t connect to the servers.';

  @override
  String get createSubjectsToTrackMarks =>
      'Create some subjects via the schedule page to start tracking marks!';

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
  String dateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get days => 'Days';

  @override
  String get defaultExamTypeNotice => 'This is the default Exam Type';

  @override
  String get defaultScheduleSetupHeader =>
      'Before you can start using the schedule, we need to know some last details about your day.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteLessonTooltip => 'Delete this lesson';

  @override
  String get deleteMark => 'Delete Mark';

  @override
  String get deleteMarkConfirm => 'Are you sure you want to delete this mark?';

  @override
  String get deleteMarkExplanation =>
      'If your semester ended, you can mark this for all marks in the app settings. We\'ll hide them from view but keep them internally for statistics on how you\'ve improved over time.';

  @override
  String get diverse => 'Diverse';

  @override
  String get edit => 'Edit';

  @override
  String get editSchedule => 'Edit Schedule';

  @override
  String get enabled => 'Enabled';

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
  String get enterTitleHint => 'Enter Title (e.g. Book p. 5)';

  @override
  String get enterUsernameHint => 'Enter your username';

  @override
  String get enterValidNonNegativeNumberError =>
      'Enter a valid non-negative full number';

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
  String get errorPrefix => 'Error';

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
  String examFactorNotice(String factor, String childType) {
    return 'Every exam in this group is worth ${factor}x as much as a exam of the $childType type';
  }

  @override
  String examGroupPercentageNotice(String percentage) {
    return 'This Exam Group is worth $percentage%';
  }

  @override
  String get examsPercentageContributionLabel =>
      'These exams will contribute to your final grade, accounting for';

  @override
  String get examsWorthLabel => 'The exams with this type are worth:';

  @override
  String get examType => 'Exam Type';

  @override
  String get examTypeNameEmptyError => 'Exam type name cannot be empty';

  @override
  String get examTypeNameLabel => 'Exam Type Name';

  @override
  String get factorLabel => 'Factor';

  @override
  String get factorPositiveIntegerError => 'Factor must be a positive integer';

  @override
  String failedToSaveUsername(String error) {
    return 'Failed to save username: $error';
  }

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
  String get gradingSetupSubtitle =>
      'Before we start, we need details about your grading system.';

  @override
  String get gradingSetupTitle => 'Grading Setup';

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
  String get hours => 'Hours';

  @override
  String get invalidCredentialsMessage =>
      'Invalid credentials.\nIf you signed up with Google, try signing in with Google.';

  @override
  String get isBaseExamType => 'This is the base exam type';

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
  String get mark => 'Mark';

  @override
  String get markDeletedSuccessfully => 'Mark deleted successfully!';

  @override
  String get marksTitle => 'Marks';

  @override
  String get minutes => 'Minutes';

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
  String get noSubjectsTitle => 'You have no subjects';

  @override
  String get noTeachersSetup => 'You haven\'t setup any teachers yet';

  @override
  String get notificationsTab => 'Notifications';

  @override
  String get noUpcomingHolidays => 'No upcoming holidays found.';

  @override
  String get noUserSettings => 'No user settings found.';

  @override
  String get ok => 'Ok';

  @override
  String get openTab => 'Open';

  @override
  String get orLabel => 'or';

  @override
  String get percentageMustBeNumberError => 'Percentage must be a number';

  @override
  String get percentageRangeError => 'Percentage must be > 0 and < 100';

  @override
  String get pleaseChooseUsername => 'Please choose a username to continue.';

  @override
  String get pleaseEnterSomething => 'Please enter something';

  @override
  String get pleaseEnterUsername => 'Please enter a username';

  @override
  String get pleaseProvideTitle => 'Please provide a title';

  @override
  String get pleaseSelectHandInTime => 'Please select a hand in time!';

  @override
  String get pleaseSelectSubject =>
      'Please select a subject for this homework!';

  @override
  String get preLessonNotificationsSubtitle =>
      'Get notified before a lesson so you don\'t have to look up the location';

  @override
  String get preLessonNotificationsTitle => 'Pre-Lesson Notifications';

  @override
  String get profileSetUpTitle => 'Profile Set Up';

  @override
  String get profileTitle => 'Profile';

  @override
  String get recentMarks => 'Recent marks:';

  @override
  String remainingTime(String time) {
    return 'Remaining: $time';
  }

  @override
  String get requiredFields => '* Required fields';

  @override
  String get residenceSubtitle =>
      'Tell us where you live, so we can calculate the next school holidays.';

  @override
  String get residenceTitle => 'Residence';

  @override
  String get retry => 'Retry';

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
  String get schoolDayProgress => 'School Day Progress';

  @override
  String get searchCountryHint => 'Search for a country...';

  @override
  String get searchStateHint => 'Search for a state...';

  @override
  String get seconds => 'Seconds';

  @override
  String get selectEndTime => 'Select end time';

  @override
  String get selectFromSchedule => 'Select from Schedule';

  @override
  String get selectFutureDate => 'Select a date in the future!';

  @override
  String get selectGradingSystemHint => 'Select Grading System';

  @override
  String get selectLabel => 'Select';

  @override
  String get selectLessonDaysPrompt =>
      'Please select the days you have lessons.';

  @override
  String get selectMark => 'Select Mark';

  @override
  String get selectStartTime => 'Select start time';

  @override
  String get selectStateProvince => 'Select your state/province';

  @override
  String get selectSubjectToAddToSchedule =>
      'Select a subject to add to the schedule';

  @override
  String get selectTeacher => 'Select a teacher';

  @override
  String get serverConnectionError =>
      'We couldn\'t connect to the server to check your settings. Please check your internet connection.';

  @override
  String get setTime => 'Set Time';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get signUpSuccessMessage =>
      'Sign up successful. Please check your email.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get subject => 'Subject';

  @override
  String get subjectNameLabel => 'Subject Name';

  @override
  String get subjectValidationAlert =>
      'Please provide a valid name and teacher for this subject.';

  @override
  String get takeMeThere => 'Take me there';

  @override
  String get teacherLabel => 'Teacher';

  @override
  String get teacherValidationAlert =>
      'Please provide a valid name and form of address for this teacher.';

  @override
  String get timesAsLabel => 'times as';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get update => 'Update';

  @override
  String get updatedHomeworkSuccessfully => 'Updated Homework successfully!';

  @override
  String get updatedMarkSuccessfully => 'Updated Mark successfully!';

  @override
  String get updatedScheduleSuccess => 'Updated Schedule Successfully!';

  @override
  String get updateLessonButton => 'Update Lesson';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameTooShort => 'Username must be at least 3 characters long';

  @override
  String verificationCodeSent(String email) {
    return 'Verification code sent to $email';
  }

  @override
  String get weekLabel => 'Week';

  @override
  String weekLabelWithLetter(String letter) {
    return '$letter Weeks';
  }

  @override
  String get welcomeGreeting => 'Ready for another productive day?';

  @override
  String get welcomeToSchoolMate => 'Welcome to SchoolMate';

  @override
  String get weWillCalculateWeeks =>
      'We will calculate the following weeks for you!';

  @override
  String get whereDoYouLive => 'Where do you live?';

  @override
  String get whichSubjectHomeworkFor => 'Which subject is this homework for?';

  @override
  String get whichWeekToday => 'Which week is today?';

  @override
  String get withDecimals => 'With Decimals';
}

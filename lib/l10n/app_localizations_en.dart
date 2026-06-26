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
  String get days => 'days';

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
  String get hours => 'hours';

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
  String get minutes => 'minutes';

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

  @override
  String get date => 'Date';

  @override
  String get whenHomeworkCompleted =>
      'When does this homework need to be completed?';

  @override
  String inTime(String amount, String unit) {
    return 'In $amount $unit';
  }

  @override
  String get handInHomeworkQuestion => 'Hand in Homework?';

  @override
  String get handInHomeworkNotification =>
      'We will notify you before the deadline, so you don\'t forget to submit your work.';

  @override
  String get handInHomeworkNoNotification =>
      'We won\'t notify you if this task is marked as completed!';

  @override
  String get selectTime => 'Select Time';

  @override
  String get year => 'year';

  @override
  String get years => 'years';

  @override
  String get day => 'day';

  @override
  String get hour => 'hour';

  @override
  String get minute => 'minute';

  @override
  String homeworkDueDate(
      String weekday, String date, String amount, String unit) {
    return '$weekday. $date | In $amount $unit';
  }

  @override
  String timeAgo(String amount, String unit) {
    return '$amount $unit ago';
  }

  @override
  String get showLess => 'Show less';

  @override
  String get showMore => 'Show more';

  @override
  String get noSubjectsFoundError =>
      'No subjects found. Please set them up in the schedule tab first.';

  @override
  String percentageWeight(String percentage) {
    return '$percentage% Weight';
  }

  @override
  String multiplicationMultiplier(String factor) {
    return '${factor}x Multiplier';
  }

  @override
  String basedOnChildType(String childType) {
    return 'Based on $childType';
  }

  @override
  String editMarkForSubject(String subject) {
    return 'Edit Mark for $subject';
  }

  @override
  String newMarkForSubject(String subject) {
    return 'New Mark for $subject';
  }

  @override
  String get useBackButtonToCarryOutChanges =>
      'Use the back button to carry out changes to this mark.';

  @override
  String get markValue => 'Mark Value';

  @override
  String get markModifiers => 'Mark Modifiers';

  @override
  String get description => 'Description';

  @override
  String get noScheduleAvailable => 'No schedule available';

  @override
  String errorLoadingMarks(String error) {
    return 'Error loading marks data: $error';
  }

  @override
  String get studyTip => 'Study Tip';

  @override
  String get percentage => 'Percentage';

  @override
  String get multiplicationBased => 'Multiplication-based';

  @override
  String get percentageBasedEvaluationTitle => 'Percentage-based Evaluation:';

  @override
  String get percentageBasedEvaluationDesc =>
      'The final grade is calculated by averaging all exams within each category (e.g., homework and tests). Then, each category\'s average is weighted based on its importance to determine the overall result.\n\nFor example, if homework and tests contribute differently to the final grade, the formula would be:\n';

  @override
  String get percentageBasedEvaluationFormula =>
      'Final Grade = (Average of Homework × its weight + Average of Tests × its weight) / Total weight';

  @override
  String get multiplicationBasedEvaluationTitle =>
      'Multiplication-based Evaluation:';

  @override
  String get multiplicationBasedEvaluationDescPart1 =>
      'In this method, each exam in a group is counted as multiple exams based on its weight.\n\n';

  @override
  String get multiplicationBasedEvaluationDescPart2 =>
      'For example, if a class paper is worth twice as much as a normal test, it will be counted as two exams when calculating the final grade\n\n';

  @override
  String get multiplicationBasedEvaluationDescPart3 =>
      'This way, some exams contribute more to the final result than others';

  @override
  String get perfectAdjusted => 'Perfect! You\'re good to go!';

  @override
  String get keepAdjusting => 'Keep adjusting until the total is 100%';

  @override
  String get errorSelectGradingSystemDropdown =>
      'Please select a grading system from the dropdown.';

  @override
  String get errorCreateAtLeastOneExamType => 'Create at least one exam type!';

  @override
  String get errorSameEvaluationMethod =>
      'All exam types must have the same evaluation method!';

  @override
  String get errorFillNameForEachExamType =>
      'Fill in a name for each exam type!';

  @override
  String get errorFillPercentageForEachExamType =>
      'Fill in a percentage for each percentage-based exam type!';

  @override
  String get errorFillFactorForEachExamType =>
      'Fill in a multiplication factor for each multiplication-based exam type!';

  @override
  String get errorOneBaseMultiplicationExamType =>
      'There may only be one base multiplication exam type!';

  @override
  String get errorSumOfPercentagesMustBe100 =>
      'The sum of all percentages must be 100';

  @override
  String get errorFactorMustBeGreaterThanZero =>
      'The multiplication factor must be greater than zero!';

  @override
  String get errorAvoidCircularDependency =>
      'Avoid circular dependency in multiplication-based exam types!';

  @override
  String get errorExamTypeNamesUnique =>
      'Each exam type must have a unique name!';

  @override
  String gradingBestWorstExplanation(String best, String worst) {
    return 'The best mark is $best and the worst mark is $worst';
  }

  @override
  String get gradingModifiersExplanation =>
      'Additionally each mark can also get a + or - assigned';

  @override
  String get gradingDecimalsExplanation =>
      'It is possible to assign decimal values';

  @override
  String get gradingExamsWeightingPrompt =>
      'Are there different types of exams?\n How are your marks weighted?';

  @override
  String get addAssignment => 'Add Assignment';

  @override
  String get addHomeworkDueThisLesson => 'Add Homework due this lesson';

  @override
  String get createAssignmentForThisLesson =>
      'Create assignment for this lesson';

  @override
  String get whenFirstLessonStarts => 'When does your first lesson start?';

  @override
  String get lessonsStartAt => 'Lessons start at';

  @override
  String get whenLastLessonEnds => 'When does your last lesson end?';

  @override
  String get lessonsEndAt => 'Lessons end at';

  @override
  String get setLabel => 'Set';

  @override
  String welcomeUsername(String username) {
    return 'Welcome $username';
  }

  @override
  String get residenceUpdate => 'Residence Update';

  @override
  String get thanksSigningUp => 'Thanks for signing up!';

  @override
  String get updateCurrentResidence => 'Update your current residence';

  @override
  String get setupIntroOnboarding =>
      'Before you can start using SchoolMate, we need to know some last details about you.';

  @override
  String get setupIntroUpdate =>
      'We will use this info to calculate the next school holidays.';

  @override
  String get beforeDeadline => 'before a deadline';

  @override
  String get beforeLessonStarts => 'before the lesson starts';

  @override
  String get pickATime => 'Pick a Time';

  @override
  String get studyTip1 =>
      'Break study sessions into 25-minute chunks with 5-minute breaks ⏳';

  @override
  String get studyTip2 =>
      'Teach concepts to a friend to reinforce your understanding 👩‍‍🏫';

  @override
  String get studyTip3 => 'Create colorful mind maps for visual learning 🎨';

  @override
  String get studyTip4 =>
      'Use the Pomodoro technique for focused productivity 🍅';

  @override
  String get studyTip5 => 'Test yourself with flashcards for active recall 🗂️';

  @override
  String get studyTip6 =>
      'Study in natural light to reduce eye strain and boost mood ☀️';

  @override
  String get studyTip7 =>
      'Record voice notes of key ideas to listen while walking 🎧';

  @override
  String get studyTip8 =>
      'Start with the hardest task when your energy is highest 💪';

  @override
  String get studyTip9 => 'Organize notes with color-coded highlighters 🌈';

  @override
  String get studyTip10 =>
      'Stretch every 30 minutes to improve circulation 🧘‍♂️';

  @override
  String get studyTip11 =>
      'Keep a water bottle nearby to stay hydrated and focused 💧';

  @override
  String get studyTip12 =>
      'Use website blockers to minimize digital distractions 🚫';

  @override
  String get studyTip13 =>
      'Review notes for 15 minutes before bed for better retention 🌙';

  @override
  String get studyTip14 =>
      'Create a lo-fi study playlist to maintain concentration 🎶';

  @override
  String get studyTip15 => 'Practice past exams under timed conditions ⏱️';

  @override
  String get studyTip16 => 'Use mnemonics like \'ROYGBIV\' for memorization 🧠';

  @override
  String get studyTip17 => 'Snack on brain foods like nuts and blueberries 🫐';

  @override
  String get studyTip18 => 'Declutter your workspace for mental clarity 🧹';

  @override
  String get studyTip19 =>
      'Reward yourself with a small treat after milestones 🎉';

  @override
  String get studyTip20 => 'Schedule weekly goals and celebrate progress 📆';

  @override
  String get motivationalQuote1 => 'Progress over perfection 🌱';

  @override
  String get motivationalQuote2 =>
      'You don’t have to be great to start – just start 💫';

  @override
  String get motivationalQuote3 =>
      'Every page turned is a step closer to mastery 📖';

  @override
  String get motivationalQuote4 => 'Mistakes are proof you’re growing 🌻';

  @override
  String get motivationalQuote5 =>
      'Your pace is valid – comparison steals joy 🐢⚡';

  @override
  String get motivationalQuote6 =>
      'Resting is part of the journey, not quitting 💤';

  @override
  String get motivationalQuote7 => 'The expert was once a curious beginner 🔍';

  @override
  String get motivationalQuote8 => 'Small efforts compound into big results 🧱';

  @override
  String get motivationalQuote9 =>
      'Courage is quiet persistence, not loud perfection 🦁';

  @override
  String get motivationalQuote10 =>
      'You’ve survived 100% of your toughest days 💯';

  @override
  String get motivationalQuote11 =>
      'Learning is planting seeds for tomorrow’s forest 🌳';

  @override
  String get motivationalQuote12 =>
      'Your brain grows stronger with every challenge 💪🧠';

  @override
  String get motivationalQuote13 =>
      'The best time to start was yesterday. The next best time is now 🕒';

  @override
  String get motivationalQuote14 =>
      'You’re not failing – you’re discovering what works 🔄';

  @override
  String get motivationalQuote15 => 'Curiosity is the compass to wisdom 🧭';

  @override
  String get motivationalQuote16 => 'Your potential is an ocean – dive in 🌊';

  @override
  String get motivationalQuote17 => 'One chapter at a time writes the story 📝';

  @override
  String get motivationalQuote18 =>
      'Burnout isn’t a badge of honor – balance is key ⚖️';

  @override
  String get motivationalQuote19 =>
      'You’re building wings while learning to fly 🦅';

  @override
  String get motivationalQuote20 =>
      'Today’s effort is tomorrow’s foundation 🏗️';

  @override
  String noCountriesFound(String query) {
    return 'No countries found matching \'$query\'';
  }

  @override
  String get noStatesAvailable =>
      'There aren\'t any states available for your country.';

  @override
  String get continueWithoutState => 'Continue without state selection';

  @override
  String noStatesFound(String query) {
    return 'No states found matching \'$query\'';
  }

  @override
  String dontLiveInCountry(String country) {
    return 'I don\'t live in $country';
  }

  @override
  String get emailVerificationSent =>
      'We have sent you an email with a verification code.';

  @override
  String get enterCodeToVerify =>
      'Enter the code below to verify your account:';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendInSeconds(String seconds) {
    return 'Resend in $seconds seconds';
  }

  @override
  String get noMarks => 'No Marks';
}

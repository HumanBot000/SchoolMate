import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @abcWeeks.
  ///
  /// In en, this message translates to:
  /// **'A/B/C Weeks'**
  String get abcWeeks;

  /// No description provided for @abWeeks.
  ///
  /// In en, this message translates to:
  /// **'A/B Weeks'**
  String get abWeeks;

  /// No description provided for @accountConflictMessageEmail.
  ///
  /// In en, this message translates to:
  /// **'An account with this email is already registered.\n\nIf you originally registered with Google, please use \'Continue with Google\'. Otherwise, try to log in using your password.'**
  String get accountConflictMessageEmail;

  /// No description provided for @accountConflictMessageGoogle.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists (registered with email and password).\n\nPlease sign in using your email and password instead.'**
  String get accountConflictMessageGoogle;

  /// No description provided for @accountConflictMessageProvider.
  ///
  /// In en, this message translates to:
  /// **'This email is already linked to another login provider (such as Google).\n\nPlease log in using \'Continue with Google\'.'**
  String get accountConflictMessageProvider;

  /// No description provided for @accountConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Conflict'**
  String get accountConflictTitle;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addedHomeworkSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added Homework successfully!'**
  String get addedHomeworkSuccessfully;

  /// No description provided for @addExamTypeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a new Exam Type'**
  String get addExamTypeTooltip;

  /// No description provided for @addHomeworkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a Homework'**
  String get addHomeworkTooltip;

  /// No description provided for @additionalNote.
  ///
  /// In en, this message translates to:
  /// **'Additional Note'**
  String get additionalNote;

  /// No description provided for @addLessonButton.
  ///
  /// In en, this message translates to:
  /// **'Add Lesson'**
  String get addLessonButton;

  /// No description provided for @addLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add a new lesson'**
  String get addLessonLabel;

  /// No description provided for @addMarkDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Add details about this mark...'**
  String get addMarkDetailsHint;

  /// No description provided for @addMarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a Mark to a subject'**
  String get addMarkTooltip;

  /// No description provided for @addSubjectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a Subject'**
  String get addSubjectTooltip;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SchoolMate'**
  String get appTitle;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @aWeeks.
  ///
  /// In en, this message translates to:
  /// **'A Weeks'**
  String get aWeeks;

  /// No description provided for @backToPresentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to Present'**
  String get backToPresentTooltip;

  /// No description provided for @baseExamTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Base Exam Type'**
  String get baseExamTypeLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changeColor.
  ///
  /// In en, this message translates to:
  /// **'Change Color'**
  String get changeColor;

  /// No description provided for @changeLessonDurationPrompt.
  ///
  /// In en, this message translates to:
  /// **'You can change this later for each individual lesson.'**
  String get changeLessonDurationPrompt;

  /// No description provided for @checkConnectionAndTry.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get checkConnectionAndTry;

  /// No description provided for @chooseUsernameTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Username'**
  String get chooseUsernameTitle;

  /// No description provided for @completedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTab;

  /// No description provided for @configureLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure a Lesson'**
  String get configureLessonTitle;

  /// No description provided for @configureScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure your schedule to start tracking your lessons.'**
  String get configureScheduleSubtitle;

  /// No description provided for @configureTeacher.
  ///
  /// In en, this message translates to:
  /// **'Configure a Teacher'**
  String get configureTeacher;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @couldNotConnectToServers.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t connect to the servers.'**
  String get couldNotConnectToServers;

  /// No description provided for @createSubjectsToTrackMarks.
  ///
  /// In en, this message translates to:
  /// **'Create some subjects via the schedule page to start tracking marks!'**
  String get createSubjectsToTrackMarks;

  /// No description provided for @createSubjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a Subject'**
  String get createSubjectTitle;

  /// No description provided for @currentWeekPrompt.
  ///
  /// In en, this message translates to:
  /// **'What type of week is the current one?'**
  String get currentWeekPrompt;

  /// No description provided for @currentWeekTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'The current week type must be included in the number of weeks'**
  String get currentWeekTypeRequired;

  /// No description provided for @customLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customLabel;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @dateAtTime.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String dateAtTime(String date, String time);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @defaultExamTypeNotice.
  ///
  /// In en, this message translates to:
  /// **'This is the default Exam Type'**
  String get defaultExamTypeNotice;

  /// No description provided for @defaultScheduleSetupHeader.
  ///
  /// In en, this message translates to:
  /// **'Before you can start using the schedule, we need to know some last details about your day.'**
  String get defaultScheduleSetupHeader;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteLessonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete this lesson'**
  String get deleteLessonTooltip;

  /// No description provided for @deleteMark.
  ///
  /// In en, this message translates to:
  /// **'Delete Mark'**
  String get deleteMark;

  /// No description provided for @deleteMarkConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this mark?'**
  String get deleteMarkConfirm;

  /// No description provided for @deleteMarkExplanation.
  ///
  /// In en, this message translates to:
  /// **'If your semester ended, you can mark this for all marks in the app settings. We\'ll hide them from view but keep them internally for statistics on how you\'ve improved over time.'**
  String get deleteMarkExplanation;

  /// No description provided for @diverse.
  ///
  /// In en, this message translates to:
  /// **'Diverse'**
  String get diverse;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get editSchedule;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @enjoyFreeTime.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your free time!'**
  String get enjoyFreeTime;

  /// No description provided for @enterFormOfAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter the form of address'**
  String get enterFormOfAddress;

  /// No description provided for @enterStartEndTimesPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter the maximum start and end times.\n You can change this later for each individual day. '**
  String get enterStartEndTimesPrompt;

  /// No description provided for @enterSubjectNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Subject Name'**
  String get enterSubjectNameHint;

  /// No description provided for @enterSubjectNameInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of the subject'**
  String get enterSubjectNameInstruction;

  /// No description provided for @enterTeacherName.
  ///
  /// In en, this message translates to:
  /// **'Enter the teacher\'s name'**
  String get enterTeacherName;

  /// No description provided for @enterTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Title (e.g. Book p. 5)'**
  String get enterTitleHint;

  /// No description provided for @enterUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsernameHint;

  /// No description provided for @enterValidNonNegativeNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid non-negative full number'**
  String get enterValidNonNegativeNumberError;

  /// No description provided for @errorEndTimeAfterStartTime.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time!'**
  String get errorEndTimeAfterStartTime;

  /// No description provided for @errorLessonOverlaps.
  ///
  /// In en, this message translates to:
  /// **'This lesson overlaps with another one!\nChange the length of the other lesson first!'**
  String get errorLessonOverlaps;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading user settings: {error}'**
  String errorLoadingSettings(String error);

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPrefix;

  /// No description provided for @errorSelectAtLeastOneWeek.
  ///
  /// In en, this message translates to:
  /// **'Select at least one week type to add a lesson to!'**
  String get errorSelectAtLeastOneWeek;

  /// No description provided for @errorSelectStartEndTimes.
  ///
  /// In en, this message translates to:
  /// **'Select when this lesson starts and ends!'**
  String get errorSelectStartEndTimes;

  /// No description provided for @errorTimesWithinSchoolDay.
  ///
  /// In en, this message translates to:
  /// **'Start and end times must be within the school day!'**
  String get errorTimesWithinSchoolDay;

  /// No description provided for @errorUnresolvedProblems.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t fixed all problems!'**
  String get errorUnresolvedProblems;

  /// No description provided for @examFactorNotice.
  ///
  /// In en, this message translates to:
  /// **'Every exam in this group is worth {factor}x as much as a exam of the {childType} type'**
  String examFactorNotice(String factor, String childType);

  /// No description provided for @examGroupPercentageNotice.
  ///
  /// In en, this message translates to:
  /// **'This Exam Group is worth {percentage}%'**
  String examGroupPercentageNotice(String percentage);

  /// No description provided for @examsPercentageContributionLabel.
  ///
  /// In en, this message translates to:
  /// **'These exams will contribute to your final grade, accounting for'**
  String get examsPercentageContributionLabel;

  /// No description provided for @examsWorthLabel.
  ///
  /// In en, this message translates to:
  /// **'The exams with this type are worth:'**
  String get examsWorthLabel;

  /// No description provided for @examType.
  ///
  /// In en, this message translates to:
  /// **'Exam Type'**
  String get examType;

  /// No description provided for @examTypeNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Exam type name cannot be empty'**
  String get examTypeNameEmptyError;

  /// No description provided for @examTypeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Exam Type Name'**
  String get examTypeNameLabel;

  /// No description provided for @factorLabel.
  ///
  /// In en, this message translates to:
  /// **'Factor'**
  String get factorLabel;

  /// No description provided for @factorPositiveIntegerError.
  ///
  /// In en, this message translates to:
  /// **'Factor must be a positive integer'**
  String get factorPositiveIntegerError;

  /// No description provided for @failedToSaveUsername.
  ///
  /// In en, this message translates to:
  /// **'Failed to save username: {error}'**
  String failedToSaveUsername(String error);

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillAllRequiredFields;

  /// No description provided for @formOfAddress.
  ///
  /// In en, this message translates to:
  /// **'Form of Address'**
  String get formOfAddress;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @generalTab.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalTab;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @gradingSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Before we start, we need details about your grading system.'**
  String get gradingSetupSubtitle;

  /// No description provided for @gradingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Grading Setup'**
  String get gradingSetupTitle;

  /// No description provided for @holidayInDays.
  ///
  /// In en, this message translates to:
  /// **'{holidayName}: In {days} days 📆'**
  String holidayInDays(String holidayName, String days);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeworkDeleted.
  ///
  /// In en, this message translates to:
  /// **'This homework has been deleted!'**
  String get homeworkDeleted;

  /// No description provided for @homeworkRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Decide how often and when you want to get reminded about open homework'**
  String get homeworkRemindersSubtitle;

  /// No description provided for @homeworkRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework Reminders'**
  String get homeworkRemindersTitle;

  /// No description provided for @homeworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeworkTitle;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @invalidCredentialsMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.\nIf you signed up with Google, try signing in with Google.'**
  String get invalidCredentialsMessage;

  /// No description provided for @isBaseExamType.
  ///
  /// In en, this message translates to:
  /// **'This is the base exam type'**
  String get isBaseExamType;

  /// No description provided for @lastLessonAfterFirst.
  ///
  /// In en, this message translates to:
  /// **'Your last lesson must end after your first lesson starts.'**
  String get lastLessonAfterFirst;

  /// No description provided for @lessonDurationInfo.
  ///
  /// In en, this message translates to:
  /// **'Each lesson is {minutes} minutes long'**
  String lessonDurationInfo(String minutes);

  /// No description provided for @lessonDurationPrompt.
  ///
  /// In en, this message translates to:
  /// **'How long are your lessons?'**
  String get lessonDurationPrompt;

  /// No description provided for @lessonEndPrompt.
  ///
  /// In en, this message translates to:
  /// **'When does this lesson end?'**
  String get lessonEndPrompt;

  /// No description provided for @lessonStartPrompt.
  ///
  /// In en, this message translates to:
  /// **'When does this lesson start?'**
  String get lessonStartPrompt;

  /// No description provided for @lessonTimesOverlap.
  ///
  /// In en, this message translates to:
  /// **'The provided lesson times may not overlap each other'**
  String get lessonTimesOverlap;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out of your account.'**
  String get logoutConfirmMessage;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @mark.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get mark;

  /// No description provided for @markDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Mark deleted successfully!'**
  String get markDeletedSuccessfully;

  /// No description provided for @marksTitle.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get marksTitle;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutesValue(String minutes);

  /// No description provided for @minutesValueShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesValueShort(String minutes);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @noClassesToday.
  ///
  /// In en, this message translates to:
  /// **'No Classes Today'**
  String get noClassesToday;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get noDataAvailable;

  /// No description provided for @noHolidaysForLocation.
  ///
  /// In en, this message translates to:
  /// **'No upcoming holidays found for your location.'**
  String get noHolidaysForLocation;

  /// No description provided for @noSubjectsCreated.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created any subjects yet'**
  String get noSubjectsCreated;

  /// No description provided for @noSubjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'You have no subjects'**
  String get noSubjectsTitle;

  /// No description provided for @noTeachersSetup.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t setup any teachers yet'**
  String get noTeachersSetup;

  /// No description provided for @notificationsTab.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTab;

  /// No description provided for @noUpcomingHolidays.
  ///
  /// In en, this message translates to:
  /// **'No upcoming holidays found.'**
  String get noUpcomingHolidays;

  /// No description provided for @noUserSettings.
  ///
  /// In en, this message translates to:
  /// **'No user settings found.'**
  String get noUserSettings;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @openTab.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openTab;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orLabel;

  /// No description provided for @percentageMustBeNumberError.
  ///
  /// In en, this message translates to:
  /// **'Percentage must be a number'**
  String get percentageMustBeNumberError;

  /// No description provided for @percentageRangeError.
  ///
  /// In en, this message translates to:
  /// **'Percentage must be > 0 and < 100'**
  String get percentageRangeError;

  /// No description provided for @pleaseChooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Please choose a username to continue.'**
  String get pleaseChooseUsername;

  /// No description provided for @pleaseEnterSomething.
  ///
  /// In en, this message translates to:
  /// **'Please enter something'**
  String get pleaseEnterSomething;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get pleaseEnterUsername;

  /// No description provided for @pleaseProvideTitle.
  ///
  /// In en, this message translates to:
  /// **'Please provide a title'**
  String get pleaseProvideTitle;

  /// No description provided for @pleaseSelectHandInTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a hand in time!'**
  String get pleaseSelectHandInTime;

  /// No description provided for @pleaseSelectSubject.
  ///
  /// In en, this message translates to:
  /// **'Please select a subject for this homework!'**
  String get pleaseSelectSubject;

  /// No description provided for @preLessonNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified before a lesson so you don\'t have to look up the location'**
  String get preLessonNotificationsSubtitle;

  /// No description provided for @preLessonNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-Lesson Notifications'**
  String get preLessonNotificationsTitle;

  /// No description provided for @profileSetUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Set Up'**
  String get profileSetUpTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @recentMarks.
  ///
  /// In en, this message translates to:
  /// **'Recent marks:'**
  String get recentMarks;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {time}'**
  String remainingTime(String time);

  /// No description provided for @requiredFields.
  ///
  /// In en, this message translates to:
  /// **'* Required fields'**
  String get requiredFields;

  /// No description provided for @residenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us where you live, so we can calculate the next school holidays.'**
  String get residenceSubtitle;

  /// No description provided for @residenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get residenceTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @roomNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Number'**
  String get roomNumberLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @scheduleChangeWeeksPrompt.
  ///
  /// In en, this message translates to:
  /// **'Does your schedule change every x weeks?'**
  String get scheduleChangeWeeksPrompt;

  /// No description provided for @scheduleCorruptionWarning.
  ///
  /// In en, this message translates to:
  /// **'Please note, that this might corrupt your current schedule. We highly encourage you to clear all lessons.'**
  String get scheduleCorruptionWarning;

  /// No description provided for @scheduleSetup.
  ///
  /// In en, this message translates to:
  /// **'Schedule Setup'**
  String get scheduleSetup;

  /// No description provided for @scheduleSetupWarning.
  ///
  /// In en, this message translates to:
  /// **'Before you can add lessons and homeworks, please give us some details about your day. You don\'t have to add in your exact schedule in order to use these features.'**
  String get scheduleSetupWarning;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @schoolDayProgress.
  ///
  /// In en, this message translates to:
  /// **'School Day Progress'**
  String get schoolDayProgress;

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a country...'**
  String get searchCountryHint;

  /// No description provided for @searchStateHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a state...'**
  String get searchStateHint;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @selectEndTime.
  ///
  /// In en, this message translates to:
  /// **'Select end time'**
  String get selectEndTime;

  /// No description provided for @selectFromSchedule.
  ///
  /// In en, this message translates to:
  /// **'Select from Schedule'**
  String get selectFromSchedule;

  /// No description provided for @selectFutureDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date in the future!'**
  String get selectFutureDate;

  /// No description provided for @selectGradingSystemHint.
  ///
  /// In en, this message translates to:
  /// **'Select Grading System'**
  String get selectGradingSystemHint;

  /// No description provided for @selectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectLabel;

  /// No description provided for @selectLessonDaysPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select the days you have lessons.'**
  String get selectLessonDaysPrompt;

  /// No description provided for @selectMark.
  ///
  /// In en, this message translates to:
  /// **'Select Mark'**
  String get selectMark;

  /// No description provided for @selectStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get selectStartTime;

  /// No description provided for @selectStateProvince.
  ///
  /// In en, this message translates to:
  /// **'Select your state/province'**
  String get selectStateProvince;

  /// No description provided for @selectSubjectToAddToSchedule.
  ///
  /// In en, this message translates to:
  /// **'Select a subject to add to the schedule'**
  String get selectSubjectToAddToSchedule;

  /// No description provided for @selectTeacher.
  ///
  /// In en, this message translates to:
  /// **'Select a teacher'**
  String get selectTeacher;

  /// No description provided for @serverConnectionError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t connect to the server to check your settings. Please check your internet connection.'**
  String get serverConnectionError;

  /// No description provided for @setTime.
  ///
  /// In en, this message translates to:
  /// **'Set Time'**
  String get setTime;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful. Please check your email.'**
  String get signUpSuccessMessage;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @subjectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject Name'**
  String get subjectNameLabel;

  /// No description provided for @subjectValidationAlert.
  ///
  /// In en, this message translates to:
  /// **'Please provide a valid name and teacher for this subject.'**
  String get subjectValidationAlert;

  /// No description provided for @takeMeThere.
  ///
  /// In en, this message translates to:
  /// **'Take me there'**
  String get takeMeThere;

  /// No description provided for @teacherLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacherLabel;

  /// No description provided for @teacherValidationAlert.
  ///
  /// In en, this message translates to:
  /// **'Please provide a valid name and form of address for this teacher.'**
  String get teacherValidationAlert;

  /// No description provided for @timesAsLabel.
  ///
  /// In en, this message translates to:
  /// **'times as'**
  String get timesAsLabel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updatedHomeworkSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated Homework successfully!'**
  String get updatedHomeworkSuccessfully;

  /// No description provided for @updatedMarkSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated Mark successfully!'**
  String get updatedMarkSuccessfully;

  /// No description provided for @updatedScheduleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated Schedule Successfully!'**
  String get updatedScheduleSuccess;

  /// No description provided for @updateLessonButton.
  ///
  /// In en, this message translates to:
  /// **'Update Lesson'**
  String get updateLessonButton;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters long'**
  String get usernameTooShort;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to {email}'**
  String verificationCodeSent(String email);

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekLabel;

  /// No description provided for @weekLabelWithLetter.
  ///
  /// In en, this message translates to:
  /// **'{letter} Weeks'**
  String weekLabelWithLetter(String letter);

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Ready for another productive day?'**
  String get welcomeGreeting;

  /// No description provided for @welcomeToSchoolMate.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SchoolMate'**
  String get welcomeToSchoolMate;

  /// No description provided for @weWillCalculateWeeks.
  ///
  /// In en, this message translates to:
  /// **'We will calculate the following weeks for you!'**
  String get weWillCalculateWeeks;

  /// No description provided for @whereDoYouLive.
  ///
  /// In en, this message translates to:
  /// **'Where do you live?'**
  String get whereDoYouLive;

  /// No description provided for @whichSubjectHomeworkFor.
  ///
  /// In en, this message translates to:
  /// **'Which subject is this homework for?'**
  String get whichSubjectHomeworkFor;

  /// No description provided for @whichWeekToday.
  ///
  /// In en, this message translates to:
  /// **'Which week is today?'**
  String get whichWeekToday;

  /// No description provided for @withDecimals.
  ///
  /// In en, this message translates to:
  /// **'With Decimals'**
  String get withDecimals;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @whenHomeworkCompleted.
  ///
  /// In en, this message translates to:
  /// **'When does this homework need to be completed?'**
  String get whenHomeworkCompleted;

  /// No description provided for @inTime.
  ///
  /// In en, this message translates to:
  /// **'In {amount} {unit}'**
  String inTime(String amount, String unit);

  /// No description provided for @handInHomeworkQuestion.
  ///
  /// In en, this message translates to:
  /// **'Hand in Homework?'**
  String get handInHomeworkQuestion;

  /// No description provided for @handInHomeworkNotification.
  ///
  /// In en, this message translates to:
  /// **'We will notify you before the deadline, so you don\'t forget to submit your work.'**
  String get handInHomeworkNotification;

  /// No description provided for @handInHomeworkNoNotification.
  ///
  /// In en, this message translates to:
  /// **'We won\'t notify you if this task is marked as completed!'**
  String get handInHomeworkNoNotification;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @homeworkDueDate.
  ///
  /// In en, this message translates to:
  /// **'{weekday}. {date} | In {amount} {unit}'**
  String homeworkDueDate(
      String weekday, String date, String amount, String unit);

  /// No description provided for @timeAgo.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} ago'**
  String timeAgo(String amount, String unit);

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @noSubjectsFoundError.
  ///
  /// In en, this message translates to:
  /// **'No subjects found. Please set them up in the schedule tab first.'**
  String get noSubjectsFoundError;

  /// No description provided for @percentageWeight.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% Weight'**
  String percentageWeight(String percentage);

  /// No description provided for @multiplicationMultiplier.
  ///
  /// In en, this message translates to:
  /// **'{factor}x Multiplier'**
  String multiplicationMultiplier(String factor);

  /// No description provided for @basedOnChildType.
  ///
  /// In en, this message translates to:
  /// **'Based on {childType}'**
  String basedOnChildType(String childType);

  /// No description provided for @editMarkForSubject.
  ///
  /// In en, this message translates to:
  /// **'Edit Mark for {subject}'**
  String editMarkForSubject(String subject);

  /// No description provided for @newMarkForSubject.
  ///
  /// In en, this message translates to:
  /// **'New Mark for {subject}'**
  String newMarkForSubject(String subject);

  /// No description provided for @useBackButtonToCarryOutChanges.
  ///
  /// In en, this message translates to:
  /// **'Use the back button to carry out changes to this mark.'**
  String get useBackButtonToCarryOutChanges;

  /// No description provided for @markValue.
  ///
  /// In en, this message translates to:
  /// **'Mark Value'**
  String get markValue;

  /// No description provided for @markModifiers.
  ///
  /// In en, this message translates to:
  /// **'Mark Modifiers'**
  String get markModifiers;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noScheduleAvailable.
  ///
  /// In en, this message translates to:
  /// **'No schedule available'**
  String get noScheduleAvailable;

  /// No description provided for @errorLoadingMarks.
  ///
  /// In en, this message translates to:
  /// **'Error loading marks data: {error}'**
  String errorLoadingMarks(String error);

  /// No description provided for @studyTip.
  ///
  /// In en, this message translates to:
  /// **'Study Tip'**
  String get studyTip;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @multiplicationBased.
  ///
  /// In en, this message translates to:
  /// **'Multiplication-based'**
  String get multiplicationBased;

  /// No description provided for @percentageBasedEvaluationTitle.
  ///
  /// In en, this message translates to:
  /// **'Percentage-based Evaluation:'**
  String get percentageBasedEvaluationTitle;

  /// No description provided for @percentageBasedEvaluationDesc.
  ///
  /// In en, this message translates to:
  /// **'The final grade is calculated by averaging all exams within each category (e.g., homework and tests). Then, each category\'s average is weighted based on its importance to determine the overall result.\n\nFor example, if homework and tests contribute differently to the final grade, the formula would be:\n'**
  String get percentageBasedEvaluationDesc;

  /// No description provided for @percentageBasedEvaluationFormula.
  ///
  /// In en, this message translates to:
  /// **'Final Grade = (Average of Homework × its weight + Average of Tests × its weight) / Total weight'**
  String get percentageBasedEvaluationFormula;

  /// No description provided for @multiplicationBasedEvaluationTitle.
  ///
  /// In en, this message translates to:
  /// **'Multiplication-based Evaluation:'**
  String get multiplicationBasedEvaluationTitle;

  /// No description provided for @multiplicationBasedEvaluationDescPart1.
  ///
  /// In en, this message translates to:
  /// **'In this method, each exam in a group is counted as multiple exams based on its weight.\n\n'**
  String get multiplicationBasedEvaluationDescPart1;

  /// No description provided for @multiplicationBasedEvaluationDescPart2.
  ///
  /// In en, this message translates to:
  /// **'For example, if a class paper is worth twice as much as a normal test, it will be counted as two exams when calculating the final grade\n\n'**
  String get multiplicationBasedEvaluationDescPart2;

  /// No description provided for @multiplicationBasedEvaluationDescPart3.
  ///
  /// In en, this message translates to:
  /// **'This way, some exams contribute more to the final result than others'**
  String get multiplicationBasedEvaluationDescPart3;

  /// No description provided for @perfectAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Perfect! You\'re good to go!'**
  String get perfectAdjusted;

  /// No description provided for @keepAdjusting.
  ///
  /// In en, this message translates to:
  /// **'Keep adjusting until the total is 100%'**
  String get keepAdjusting;

  /// No description provided for @errorSelectGradingSystemDropdown.
  ///
  /// In en, this message translates to:
  /// **'Please select a grading system from the dropdown.'**
  String get errorSelectGradingSystemDropdown;

  /// No description provided for @errorCreateAtLeastOneExamType.
  ///
  /// In en, this message translates to:
  /// **'Create at least one exam type!'**
  String get errorCreateAtLeastOneExamType;

  /// No description provided for @errorSameEvaluationMethod.
  ///
  /// In en, this message translates to:
  /// **'All exam types must have the same evaluation method!'**
  String get errorSameEvaluationMethod;

  /// No description provided for @errorFillNameForEachExamType.
  ///
  /// In en, this message translates to:
  /// **'Fill in a name for each exam type!'**
  String get errorFillNameForEachExamType;

  /// No description provided for @errorFillPercentageForEachExamType.
  ///
  /// In en, this message translates to:
  /// **'Fill in a percentage for each percentage-based exam type!'**
  String get errorFillPercentageForEachExamType;

  /// No description provided for @errorFillFactorForEachExamType.
  ///
  /// In en, this message translates to:
  /// **'Fill in a multiplication factor for each multiplication-based exam type!'**
  String get errorFillFactorForEachExamType;

  /// No description provided for @errorOneBaseMultiplicationExamType.
  ///
  /// In en, this message translates to:
  /// **'There may only be one base multiplication exam type!'**
  String get errorOneBaseMultiplicationExamType;

  /// No description provided for @errorSumOfPercentagesMustBe100.
  ///
  /// In en, this message translates to:
  /// **'The sum of all percentages must be 100'**
  String get errorSumOfPercentagesMustBe100;

  /// No description provided for @errorFactorMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'The multiplication factor must be greater than zero!'**
  String get errorFactorMustBeGreaterThanZero;

  /// No description provided for @errorAvoidCircularDependency.
  ///
  /// In en, this message translates to:
  /// **'Avoid circular dependency in multiplication-based exam types!'**
  String get errorAvoidCircularDependency;

  /// No description provided for @errorExamTypeNamesUnique.
  ///
  /// In en, this message translates to:
  /// **'Each exam type must have a unique name!'**
  String get errorExamTypeNamesUnique;

  /// No description provided for @gradingBestWorstExplanation.
  ///
  /// In en, this message translates to:
  /// **'The best mark is {best} and the worst mark is {worst}'**
  String gradingBestWorstExplanation(String best, String worst);

  /// No description provided for @gradingModifiersExplanation.
  ///
  /// In en, this message translates to:
  /// **'Additionally each mark can also get a + or - assigned'**
  String get gradingModifiersExplanation;

  /// No description provided for @gradingDecimalsExplanation.
  ///
  /// In en, this message translates to:
  /// **'It is possible to assign decimal values'**
  String get gradingDecimalsExplanation;

  /// No description provided for @gradingExamsWeightingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are there different types of exams?\n How are your marks weighted?'**
  String get gradingExamsWeightingPrompt;

  /// No description provided for @addAssignment.
  ///
  /// In en, this message translates to:
  /// **'Add Assignment'**
  String get addAssignment;

  /// No description provided for @addHomeworkDueThisLesson.
  ///
  /// In en, this message translates to:
  /// **'Add Homework due this lesson'**
  String get addHomeworkDueThisLesson;

  /// No description provided for @createAssignmentForThisLesson.
  ///
  /// In en, this message translates to:
  /// **'Create assignment for this lesson'**
  String get createAssignmentForThisLesson;

  /// No description provided for @whenFirstLessonStarts.
  ///
  /// In en, this message translates to:
  /// **'When does your first lesson start?'**
  String get whenFirstLessonStarts;

  /// No description provided for @lessonsStartAt.
  ///
  /// In en, this message translates to:
  /// **'Lessons start at'**
  String get lessonsStartAt;

  /// No description provided for @whenLastLessonEnds.
  ///
  /// In en, this message translates to:
  /// **'When does your last lesson end?'**
  String get whenLastLessonEnds;

  /// No description provided for @lessonsEndAt.
  ///
  /// In en, this message translates to:
  /// **'Lessons end at'**
  String get lessonsEndAt;

  /// No description provided for @setLabel.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setLabel;

  /// No description provided for @welcomeUsername.
  ///
  /// In en, this message translates to:
  /// **'Welcome {username}'**
  String welcomeUsername(String username);

  /// No description provided for @residenceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Residence Update'**
  String get residenceUpdate;

  /// No description provided for @thanksSigningUp.
  ///
  /// In en, this message translates to:
  /// **'Thanks for signing up!'**
  String get thanksSigningUp;

  /// No description provided for @updateCurrentResidence.
  ///
  /// In en, this message translates to:
  /// **'Update your current residence'**
  String get updateCurrentResidence;

  /// No description provided for @setupIntroOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Before you can start using SchoolMate, we need to know some last details about you.'**
  String get setupIntroOnboarding;

  /// No description provided for @setupIntroUpdate.
  ///
  /// In en, this message translates to:
  /// **'We will use this info to calculate the next school holidays.'**
  String get setupIntroUpdate;

  /// No description provided for @beforeDeadline.
  ///
  /// In en, this message translates to:
  /// **'before a deadline'**
  String get beforeDeadline;

  /// No description provided for @beforeLessonStarts.
  ///
  /// In en, this message translates to:
  /// **'before the lesson starts'**
  String get beforeLessonStarts;

  /// No description provided for @pickATime.
  ///
  /// In en, this message translates to:
  /// **'Pick a Time'**
  String get pickATime;

  /// No description provided for @studyTip1.
  ///
  /// In en, this message translates to:
  /// **'Break study sessions into 25-minute chunks with 5-minute breaks ⏳'**
  String get studyTip1;

  /// No description provided for @studyTip2.
  ///
  /// In en, this message translates to:
  /// **'Teach concepts to a friend to reinforce your understanding 👩‍‍🏫'**
  String get studyTip2;

  /// No description provided for @studyTip3.
  ///
  /// In en, this message translates to:
  /// **'Create colorful mind maps for visual learning 🎨'**
  String get studyTip3;

  /// No description provided for @studyTip4.
  ///
  /// In en, this message translates to:
  /// **'Use the Pomodoro technique for focused productivity 🍅'**
  String get studyTip4;

  /// No description provided for @studyTip5.
  ///
  /// In en, this message translates to:
  /// **'Test yourself with flashcards for active recall 🗂️'**
  String get studyTip5;

  /// No description provided for @studyTip6.
  ///
  /// In en, this message translates to:
  /// **'Study in natural light to reduce eye strain and boost mood ☀️'**
  String get studyTip6;

  /// No description provided for @studyTip7.
  ///
  /// In en, this message translates to:
  /// **'Record voice notes of key ideas to listen while walking 🎧'**
  String get studyTip7;

  /// No description provided for @studyTip8.
  ///
  /// In en, this message translates to:
  /// **'Start with the hardest task when your energy is highest 💪'**
  String get studyTip8;

  /// No description provided for @studyTip9.
  ///
  /// In en, this message translates to:
  /// **'Organize notes with color-coded highlighters 🌈'**
  String get studyTip9;

  /// No description provided for @studyTip10.
  ///
  /// In en, this message translates to:
  /// **'Stretch every 30 minutes to improve circulation 🧘‍♂️'**
  String get studyTip10;

  /// No description provided for @studyTip11.
  ///
  /// In en, this message translates to:
  /// **'Keep a water bottle nearby to stay hydrated and focused 💧'**
  String get studyTip11;

  /// No description provided for @studyTip12.
  ///
  /// In en, this message translates to:
  /// **'Use website blockers to minimize digital distractions 🚫'**
  String get studyTip12;

  /// No description provided for @studyTip13.
  ///
  /// In en, this message translates to:
  /// **'Review notes for 15 minutes before bed for better retention 🌙'**
  String get studyTip13;

  /// No description provided for @studyTip14.
  ///
  /// In en, this message translates to:
  /// **'Create a lo-fi study playlist to maintain concentration 🎶'**
  String get studyTip14;

  /// No description provided for @studyTip15.
  ///
  /// In en, this message translates to:
  /// **'Practice past exams under timed conditions ⏱️'**
  String get studyTip15;

  /// No description provided for @studyTip16.
  ///
  /// In en, this message translates to:
  /// **'Use mnemonics like \'ROYGBIV\' for memorization 🧠'**
  String get studyTip16;

  /// No description provided for @studyTip17.
  ///
  /// In en, this message translates to:
  /// **'Snack on brain foods like nuts and blueberries 🫐'**
  String get studyTip17;

  /// No description provided for @studyTip18.
  ///
  /// In en, this message translates to:
  /// **'Declutter your workspace for mental clarity 🧹'**
  String get studyTip18;

  /// No description provided for @studyTip19.
  ///
  /// In en, this message translates to:
  /// **'Reward yourself with a small treat after milestones 🎉'**
  String get studyTip19;

  /// No description provided for @studyTip20.
  ///
  /// In en, this message translates to:
  /// **'Schedule weekly goals and celebrate progress 📆'**
  String get studyTip20;

  /// No description provided for @motivationalQuote1.
  ///
  /// In en, this message translates to:
  /// **'Progress over perfection 🌱'**
  String get motivationalQuote1;

  /// No description provided for @motivationalQuote2.
  ///
  /// In en, this message translates to:
  /// **'You don’t have to be great to start – just start 💫'**
  String get motivationalQuote2;

  /// No description provided for @motivationalQuote3.
  ///
  /// In en, this message translates to:
  /// **'Every page turned is a step closer to mastery 📖'**
  String get motivationalQuote3;

  /// No description provided for @motivationalQuote4.
  ///
  /// In en, this message translates to:
  /// **'Mistakes are proof you’re growing 🌻'**
  String get motivationalQuote4;

  /// No description provided for @motivationalQuote5.
  ///
  /// In en, this message translates to:
  /// **'Your pace is valid – comparison steals joy 🐢⚡'**
  String get motivationalQuote5;

  /// No description provided for @motivationalQuote6.
  ///
  /// In en, this message translates to:
  /// **'Resting is part of the journey, not quitting 💤'**
  String get motivationalQuote6;

  /// No description provided for @motivationalQuote7.
  ///
  /// In en, this message translates to:
  /// **'The expert was once a curious beginner 🔍'**
  String get motivationalQuote7;

  /// No description provided for @motivationalQuote8.
  ///
  /// In en, this message translates to:
  /// **'Small efforts compound into big results 🧱'**
  String get motivationalQuote8;

  /// No description provided for @motivationalQuote9.
  ///
  /// In en, this message translates to:
  /// **'Courage is quiet persistence, not loud perfection 🦁'**
  String get motivationalQuote9;

  /// No description provided for @motivationalQuote10.
  ///
  /// In en, this message translates to:
  /// **'You’ve survived 100% of your toughest days 💯'**
  String get motivationalQuote10;

  /// No description provided for @motivationalQuote11.
  ///
  /// In en, this message translates to:
  /// **'Learning is planting seeds for tomorrow’s forest 🌳'**
  String get motivationalQuote11;

  /// No description provided for @motivationalQuote12.
  ///
  /// In en, this message translates to:
  /// **'Your brain grows stronger with every challenge 💪🧠'**
  String get motivationalQuote12;

  /// No description provided for @motivationalQuote13.
  ///
  /// In en, this message translates to:
  /// **'The best time to start was yesterday. The next best time is now 🕒'**
  String get motivationalQuote13;

  /// No description provided for @motivationalQuote14.
  ///
  /// In en, this message translates to:
  /// **'You’re not failing – you’re discovering what works 🔄'**
  String get motivationalQuote14;

  /// No description provided for @motivationalQuote15.
  ///
  /// In en, this message translates to:
  /// **'Curiosity is the compass to wisdom 🧭'**
  String get motivationalQuote15;

  /// No description provided for @motivationalQuote16.
  ///
  /// In en, this message translates to:
  /// **'Your potential is an ocean – dive in 🌊'**
  String get motivationalQuote16;

  /// No description provided for @motivationalQuote17.
  ///
  /// In en, this message translates to:
  /// **'One chapter at a time writes the story 📝'**
  String get motivationalQuote17;

  /// No description provided for @motivationalQuote18.
  ///
  /// In en, this message translates to:
  /// **'Burnout isn’t a badge of honor – balance is key ⚖️'**
  String get motivationalQuote18;

  /// No description provided for @motivationalQuote19.
  ///
  /// In en, this message translates to:
  /// **'You’re building wings while learning to fly 🦅'**
  String get motivationalQuote19;

  /// No description provided for @motivationalQuote20.
  ///
  /// In en, this message translates to:
  /// **'Today’s effort is tomorrow’s foundation 🏗️'**
  String get motivationalQuote20;

  /// No description provided for @noCountriesFound.
  ///
  /// In en, this message translates to:
  /// **'No countries found matching \'{query}\''**
  String noCountriesFound(String query);

  /// No description provided for @noStatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'There aren\'t any states available for your country.'**
  String get noStatesAvailable;

  /// No description provided for @continueWithoutState.
  ///
  /// In en, this message translates to:
  /// **'Continue without state selection'**
  String get continueWithoutState;

  /// No description provided for @noStatesFound.
  ///
  /// In en, this message translates to:
  /// **'No states found matching \'{query}\''**
  String noStatesFound(String query);

  /// No description provided for @dontLiveInCountry.
  ///
  /// In en, this message translates to:
  /// **'I don\'t live in {country}'**
  String dontLiveInCountry(String country);

  /// No description provided for @emailVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'We have sent you an email with a verification code.'**
  String get emailVerificationSent;

  /// No description provided for @enterCodeToVerify.
  ///
  /// In en, this message translates to:
  /// **'Enter the code below to verify your account:'**
  String get enterCodeToVerify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} seconds'**
  String resendInSeconds(String seconds);

  /// No description provided for @noMarks.
  ///
  /// In en, this message translates to:
  /// **'No Marks'**
  String get noMarks;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

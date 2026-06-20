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

  /// No description provided for @addHomeworkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a Homework'**
  String get addHomeworkTooltip;

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

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

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

  /// No description provided for @marksTitle.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get marksTitle;

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

  /// No description provided for @openTab.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openTab;

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

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

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

  /// No description provided for @selectStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get selectStartTime;

  /// No description provided for @selectTeacher.
  ///
  /// In en, this message translates to:
  /// **'Select a teacher'**
  String get selectTeacher;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

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

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

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

  /// No description provided for @weWillCalculateWeeks.
  ///
  /// In en, this message translates to:
  /// **'We will calculate the following weeks for you!'**
  String get weWillCalculateWeeks;

  /// No description provided for @whichWeekToday.
  ///
  /// In en, this message translates to:
  /// **'Which week is today?'**
  String get whichWeekToday;
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

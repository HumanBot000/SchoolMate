// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get abcWeeks => 'A/B/C-Wochen';

  @override
  String get abWeeks => 'A/B-Wochen';

  @override
  String get addHomeworkTooltip => 'Hausaufgabe hinzufügen';

  @override
  String get addLessonButton => 'Stunde hinzufügen';

  @override
  String get addLessonLabel => 'Neue Stunde hinzufügen';

  @override
  String get addSubjectTooltip => 'Fach hinzufügen';

  @override
  String get appTitle => 'SchoolMate';

  @override
  String get areYouSure => 'Bist du dir sicher?';

  @override
  String get aWeeks => 'A-Wochen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get changeColor => 'Farbe ändern';

  @override
  String get changeLessonDurationPrompt =>
      'Du kannst dies später für jede einzelne Stunde ändern.';

  @override
  String get completedTab => 'Erledigt';

  @override
  String get configureLessonTitle => 'Stunde einrichten';

  @override
  String get configureScheduleSubtitle =>
      'Konfiguriere deinen Stundenplan, um deine Stunden zu verfolgen.';

  @override
  String get configureTeacher => 'Lehrkraft einrichten';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get createSubjectTitle => 'Fach erstellen';

  @override
  String get currentWeekPrompt => 'Welcher Wochentyp ist die aktuelle Woche?';

  @override
  String get currentWeekTypeRequired =>
      'Der aktuelle Wochentyp muss in der Anzahl der Wochen enthalten sein';

  @override
  String get customLabel => 'Benutzerdefiniert';

  @override
  String get dangerZone => 'Gefahrenzone';

  @override
  String get defaultScheduleSetupHeader =>
      'Bevor du den Stundenplan nutzen kannst, benötigen wir noch einige letzte Details über deinen Tag.';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteLessonTooltip => 'Diese Stunde löschen';

  @override
  String get diverse => 'Divers';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editSchedule => 'Stundenplan bearbeiten';

  @override
  String get enjoyFreeTime => 'Genieße deine freie Zeit!';

  @override
  String get enterFormOfAddress => 'Anrede eingeben';

  @override
  String get enterStartEndTimesPrompt =>
      'Bitte gib die maximalen Start- und Endzeiten ein.\n Du kannst dies später für jeden einzelnen Tag ändern. ';

  @override
  String get enterSubjectNameHint => 'Fachnamen eingeben';

  @override
  String get enterSubjectNameInstruction => 'Gib den Namen des Fachs ein';

  @override
  String get enterTeacherName => 'Namen der Lehrkraft eingeben';

  @override
  String get errorEndTimeAfterStartTime =>
      'Die Endzeit muss nach der Startzeit liegen!';

  @override
  String get errorLessonOverlaps =>
      'Diese Stunde überschneidet sich mit einer anderen!\nÄndere zuerst die Länge der anderen Stunde!';

  @override
  String errorLoadingSettings(String error) {
    return 'Fehler beim Laden der Benutzereinstellungen: $error';
  }

  @override
  String get errorSelectAtLeastOneWeek =>
      'Wähle mindestens einen Wochentyp aus, um eine Stunde hinzuzufügen!';

  @override
  String get errorSelectStartEndTimes =>
      'Wähle aus, wann diese Stunde beginnt und endet!';

  @override
  String get errorTimesWithinSchoolDay =>
      'Start- und Endzeit müssen innerhalb des Schultages liegen!';

  @override
  String get errorUnresolvedProblems =>
      'Du hast noch nicht alle Probleme behoben!';

  @override
  String get female => 'Weiblich';

  @override
  String get fillAllRequiredFields =>
      'Bitte fülle alle erforderlichen Felder aus';

  @override
  String get formOfAddress => 'Anrede';

  @override
  String get gender => 'Geschlecht';

  @override
  String get generalTab => 'Allgemein';

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String holidayInDays(String holidayName, String days) {
    return '$holidayName: In $days Tagen 📆';
  }

  @override
  String get homeTitle => 'Start';

  @override
  String get homeworkDeleted => 'Diese Hausaufgabe wurde gelöscht!';

  @override
  String get homeworkRemindersSubtitle =>
      'Entscheide, wie oft und wann du an offene Hausaufgaben erinnert werden möchtest';

  @override
  String get homeworkRemindersTitle => 'Hausaufgaben-Erinnerungen';

  @override
  String get homeworkTitle => 'Hausaufgaben';

  @override
  String get lastLessonAfterFirst =>
      'Deine letzte Stunde muss enden, nachdem deine erste Stunde beginnt.';

  @override
  String lessonDurationInfo(String minutes) {
    return 'Jede Stunde dauert $minutes Minuten';
  }

  @override
  String get lessonDurationPrompt => 'Wie lange dauern deine Stunden?';

  @override
  String get lessonEndPrompt => 'Wann endet diese Stunde?';

  @override
  String get lessonStartPrompt => 'Wann beginnt diese Stunde?';

  @override
  String get lessonTimesOverlap =>
      'Die angegebenen Unterrichtszeiten dürfen sich nicht überschneiden';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutConfirmMessage => 'Du wirst aus deinem Konto abgemeldet.';

  @override
  String get male => 'Männlich';

  @override
  String get marksTitle => 'Noten';

  @override
  String get minutesLabel => 'Minuten';

  @override
  String minutesValue(String minutes) {
    return '$minutes Minuten';
  }

  @override
  String minutesValueShort(String minutes) {
    return '$minutes Min.';
  }

  @override
  String get name => 'Name';

  @override
  String get noClassesToday => 'Kein Unterricht heute';

  @override
  String get noDataAvailable => 'Keine Daten verfügbar.';

  @override
  String get noHolidaysForLocation =>
      'Keine anstehenden Ferien für deinen Wohnort gefunden.';

  @override
  String get noSubjectsCreated => 'Du hast noch keine Fächer erstellt';

  @override
  String get noTeachersSetup => 'Du hast noch keine Lehrkräfte eingerichtet';

  @override
  String get notificationsTab => 'Benachrichtigungen';

  @override
  String get noUpcomingHolidays => 'Keine anstehenden Ferien gefunden.';

  @override
  String get noUserSettings => 'Keine Benutzereinstellungen gefunden.';

  @override
  String get openTab => 'Offen';

  @override
  String get preLessonNotificationsSubtitle =>
      'Lass dich vor einer Stunde benachrichtigen, damit du den Raum nicht nachschlagen musst';

  @override
  String get preLessonNotificationsTitle =>
      'Benachrichtigungen vor dem Unterricht';

  @override
  String get profileTitle => 'Profil';

  @override
  String get requiredFields => '* Erforderliche Felder';

  @override
  String get residenceSubtitle =>
      'Teile uns deinen Wohnort mit, damit wir die nächsten Schulferien berechnen können.';

  @override
  String get residenceTitle => 'Wohnort';

  @override
  String get roomNumberLabel => 'Raumnummer';

  @override
  String get save => 'Speichern';

  @override
  String get scheduleChangeWeeksPrompt =>
      'Ändert sich dein Stundenplan alle x Wochen?';

  @override
  String get scheduleCorruptionWarning =>
      'Bitte beachte, dass dies deinen aktuellen Stundenplan beschädigen könnte. Wir empfehlen dir dringend, alle Stunden zu löschen.';

  @override
  String get scheduleSetup => 'Stundenplan-Einrichtung';

  @override
  String get scheduleSetupWarning =>
      'Bevor du Stunden und Hausaufgaben hinzufügen kannst, teile uns bitte einige Details über deinen Tag mit. Du musst nicht deinen genauen Stundenplan angeben, um diese Funktionen zu nutzen.';

  @override
  String get scheduleTitle => 'Stundenplan';

  @override
  String get selectEndTime => 'Endzeit auswählen';

  @override
  String get selectFromSchedule => 'Aus dem Stundenplan auswählen';

  @override
  String get selectLabel => 'Auswählen';

  @override
  String get selectLessonDaysPrompt =>
      'Bitte wähle die Tage aus, an denen du Unterricht hast.';

  @override
  String get selectStartTime => 'Startzeit auswählen';

  @override
  String get selectTeacher => 'Lehrkraft auswählen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get somethingWentWrong =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get subjectNameLabel => 'Fach';

  @override
  String get subjectValidationAlert =>
      'Bitte gib einen gültigen Namen und eine Lehrkraft für dieses Fach an.';

  @override
  String get teacherLabel => 'Lehrkraft';

  @override
  String get teacherValidationAlert =>
      'Bitte gib einen gültigen Namen und eine Anrede für diesen Lehrer an.';

  @override
  String get update => 'Aktualisieren';

  @override
  String get updatedScheduleSuccess => 'Stundenplan erfolgreich aktualisiert!';

  @override
  String get updateLessonButton => 'Stunde aktualisieren';

  @override
  String get weekLabel => 'Woche';

  @override
  String weekLabelWithLetter(String letter) {
    return '$letter-Wochen';
  }

  @override
  String get welcomeGreeting => 'Bereit für einen produktiven Tag?';

  @override
  String get weWillCalculateWeeks =>
      'Wir berechnen die folgenden Wochen für dich!';

  @override
  String get whichWeekToday => 'Welche Woche ist heute?';
}

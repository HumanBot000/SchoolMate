import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/settings/preLessonNotifications.dart';
import 'package:school_mate/pages/settings/notifications/preNotifications.dart';
import 'package:school_mate/l10n/app_localizations.dart';

class PreLessonNotificationSetup extends StatelessWidget {
  const PreLessonNotificationSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return NotificationSetup(
      title: l10n.preLessonNotificationsTitle,
      itemSuffix: l10n.beforeLessonStarts,
      fetchSettings: () async {
        final list = await fetchPreLessonNotifications();
        return list
            .map((e) => NotificationSetting(e[0] as String, e[1] as int))
            .toList();
      },
      updateSettings: (items) async {
        await updatePreLessonNotifications(
          items.map((e) => [e.unit, e.value]).toList(),
        );
      },
      validateSettings: (items) {
        return preNotificationListIsValid(
          items.map((e) => [e.unit, e.value]).toList(),
        );
      },
    );
  }
}

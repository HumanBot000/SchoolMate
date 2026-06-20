import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/API/externalAPIClients/OpenHolidaysAPI.dart'
    as holiday_api;
import 'package:school_mate/API/supabase/auth/userSettings.dart' as settings;
import 'package:school_mate/Classes/schedule/SchoolHoliday.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';

Widget _upcomingHolidaysTextData(
    BuildContext context, String residenceCountry, String localResidenceCode) {
  final l10n = AppLocalizations.of(context)!;
  final currentLanguage = Localizations.localeOf(context).languageCode;
  return FutureBuilder<SchoolHoliday>(
    future: holiday_api.getUpcomingHolidays(
        residenceCountry, localResidenceCode,
        language: currentLanguage),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        logger.i(snapshot.error);
        return Text(l10n.noHolidaysForLocation);
      } else if (snapshot.hasData) {
        final holiday = snapshot.data!;
        return Text(
          l10n.holidayInDays(holiday.name, holiday.daysLeft.toString()),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(l10n.noUpcomingHolidays);
      }
    },
  );
}

class UpcomingHolidaysCard extends StatelessWidget {
  const UpcomingHolidaysCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: settings.getUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          logger.e(snapshot.error);
          final l10n = AppLocalizations.of(context)!;
          return Text(l10n.errorLoadingSettings(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          final userSettings = snapshot.data!;
          final residenceCountry = userSettings['residence_country'];
          final localResidenceCode = userSettings['residence'];
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: Lottie.asset(
                          'assets/animations/holidays.json',
                          alignment: Alignment.topCenter,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Center(
                      child: _upcomingHolidaysTextData(
                          context, residenceCountry, localResidenceCode),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          final l10n = AppLocalizations.of(context)!;
          return Text(l10n.noUserSettings);
        }
      },
    );
  }
}

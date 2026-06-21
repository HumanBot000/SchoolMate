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
        return Text(
          l10n.noHolidaysForLocation,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        );
      } else if (snapshot.hasData) {
        final holiday = snapshot.data!;
        return Text(
          l10n.holidayInDays(holiday.name, holiday.daysLeft.toString()),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          l10n.noUpcomingHolidays,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        );
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
          return Center(
            child: Text(
              l10n.errorLoadingSettings(snapshot.error.toString()),
              style: const TextStyle(color: Colors.white70),
            ),
          );
        } else if (snapshot.hasData) {
          final userSettings = snapshot.data!;
          final residenceCountry = userSettings['residence_country'];
          final localResidenceCode = userSettings['residence'];
          return Container(
            width: double.infinity,
            height: 140,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F36).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: Lottie.asset(
                      'assets/animations/holidays.json',
                      alignment: Alignment.center,
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
          );
        } else {
          final l10n = AppLocalizations.of(context)!;
          return Center(
            child: Text(
              l10n.noUserSettings,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }
      },
    );
  }
}

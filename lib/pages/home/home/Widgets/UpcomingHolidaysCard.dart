import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/API/externalAPIClients/OpenHolidaysAPI.dart'
    as holiday_api;
import 'package:school_mate/API/supabase/auth/userSettings.dart' as settings;
import 'package:school_mate/Classes/schedule/SchoolHoliday.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';

class UpcomingHolidaysCard extends StatefulWidget {
  const UpcomingHolidaysCard({super.key});

  @override
  State<UpcomingHolidaysCard> createState() => _UpcomingHolidaysCardState();
}

class _UpcomingHolidaysCardState extends State<UpcomingHolidaysCard> {
  Future<SchoolHoliday?>? _holidayFuture;
  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_holidayFuture == null || _lastLocale != locale) {
      _lastLocale = locale;
      _holidayFuture = _loadHoliday();
    }
  }

  Future<SchoolHoliday?> _loadHoliday() async {
    try {
      final userSettings = await settings.getUserSettings();
      if (userSettings == null) return null;
      final residenceCountry = userSettings['residence_country'] as String?;
      final localResidenceCode = userSettings['residence'] as String?;
      if (residenceCountry == null || localResidenceCode == null) return null;
      final currentLanguage = _lastLocale?.languageCode ?? 'en';
      return await holiday_api.getUpcomingHolidays(
        residenceCountry,
        localResidenceCode,
        language: currentLanguage,
      );
    } catch (e) {
      logger.e("Failed to load upcoming holidays", e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<SchoolHoliday?>(
      future: _holidayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          logger.i(snapshot.error);
          return _buildCardWrapper(
            child: Text(
              l10n.noHolidaysForLocation,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final holiday = snapshot.data!;
          return _buildCardWrapper(
            child: Text(
              l10n.holidayInDays(holiday.name, holiday.daysLeft.toString()),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return _buildCardWrapper(
            child: Text(
              l10n.noUpcomingHolidays,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
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
            child: child,
          ),
        ],
      ),
    );
  }
}

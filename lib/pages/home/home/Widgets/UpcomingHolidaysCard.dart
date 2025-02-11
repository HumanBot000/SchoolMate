import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/API/externalAPIClients/OpenHolidaysAPI.dart'
    as holiday_api;
import 'package:school_mate/API/supabase/auth/userSettings.dart' as settings;
import 'package:school_mate/Classes/schedule/SchoolHoliday.dart';
import 'package:school_mate/main.dart';

Widget _upcomingHolidaysTextData(
    String residenceCountry, String localResidenceCode,
    {String language = "en"}) {
  return FutureBuilder<SchoolHoliday>(
    future: holiday_api.getUpcomingHolidays(
        residenceCountry, localResidenceCode,
        language: language),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        logger.i(snapshot.error);
        return const Text('No upcoming holidays found for your location.');
      } else if (snapshot.hasData) {
        final holiday = snapshot.data!;
        return Row(children: [
          Text(
            holiday.name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Text(": In "),
          Text(holiday.daysLeft.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const Text(" days 📆"),
        ]);
      } else {
        return const Text('No upcoming holidays found.');
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
          return Text('Error loading user settings: ${snapshot.error}');
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
                          residenceCountry, localResidenceCode),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Text('No user settings found.');
        }
      },
    );
  }
}

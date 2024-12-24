import 'package:app/Classes/SchoolHoliday.dart';
import 'package:app/externalAPIClients/OpenHolidaysAPI.dart' as holiday_api;
import 'package:app/supabase/userSettings.dart' as settings;
import 'package:flutter/material.dart';

import '../../main.dart';

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
    return FutureBuilder<Map<String, dynamic>>(
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
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _upcomingHolidaysTextData(
                    residenceCountry, localResidenceCode),
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

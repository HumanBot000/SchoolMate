import 'dart:convert';

import 'package:app/Classes/SchoolHoliday.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<SchoolHoliday> getUpcomingHolidays(
    String residenceCountry, String localResidenceCode,
    {String language = "en"}) async {
  final now = DateTime.now();
  final validFrom =
      DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, now.day));
  final validTo = DateFormat('yyyy-MM-dd')
      .format(DateTime(now.year + 1, now.month, now.day));

  final url = Uri.parse("https://openholidaysapi.org/SchoolHolidays"
      "?countryIsoCode=${residenceCountry.toUpperCase()}"
      "&validFrom=$validFrom"
      "&validTo=$validTo"
      "&languageIsoCode=${language.toUpperCase()}"
      "&subdivisionCode=${residenceCountry.toUpperCase()}-${localResidenceCode.toUpperCase()}");
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch holidays: ${response.statusCode}');
  }
  final jsonResponse = jsonDecode(response.body) as List<dynamic>;
  if (jsonResponse.isEmpty) {
    throw Exception('No holidays found for the given parameters.');
  }
  final holiday = jsonResponse.firstWhere(
    (holiday) => DateTime.parse(holiday['startDate']).isAfter(now),
    orElse: () => null,
  );
  if (holiday == null) {
    throw Exception('No upcoming holidays found.');
  }

  return SchoolHoliday.fromJson(holiday as Map<String, dynamic>);
}

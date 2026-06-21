import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:school_mate/API/externalAPIClients/geoAPIs.dart';
import 'package:school_mate/Classes/geoPolitics/Country.dart';

void main() {
  test('Fetch and validate all country flags using FlagCDN PNG format',
      () async {
    final List<Country> countries = await getCountries();
    expect(countries, isNotEmpty);

    print('Fetched ${countries.length} countries. Validating PNG flags...');

    final List<String> failedCountries = [];

    // Since flagcdn.com has a robust CDN, we can use a higher concurrency limit
    const int concurrency = 20;

    for (int i = 0; i < countries.length; i += concurrency) {
      final chunk = countries.sublist(
        i,
        i + concurrency > countries.length ? countries.length : i + concurrency,
      );

      await Future.wait(chunk.map((country) async {
        try {
          final response =
              await http.get(country.flag).timeout(const Duration(seconds: 15));
          if (response.statusCode != 200) {
            failedCountries.add(
                '${country.name} (${country.code}): Status ${response.statusCode} - URL: ${country.flag}');
          } else {
            final bytes = response.bodyBytes;
            // Verify PNG file signature/magic bytes: 137, 80, 78, 71
            if (bytes.length < 4 ||
                bytes[0] != 137 ||
                bytes[1] != 80 ||
                bytes[2] != 78 ||
                bytes[3] != 71) {
              failedCountries.add(
                  '${country.name} (${country.code}): Invalid PNG signature - URL: ${country.flag}');
            }
          }
        } catch (e) {
          failedCountries.add(
              '${country.name} (${country.code}): Error $e - URL: ${country.flag}');
        }
      }));
    }

    if (failedCountries.isNotEmpty) {
      print('Failed flags list (${failedCountries.length} countries):');
      for (var f in failedCountries) {
        print('  $f');
      }
    }

    expect(failedCountries, isEmpty,
        reason: 'Some flags failed to load from flagcdn.com as PNG');
  });
}

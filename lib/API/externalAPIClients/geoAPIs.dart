import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mate/Classes/geoPolitics/Country.dart';
import 'package:school_mate/Classes/geoPolitics/SubCountryState.dart';
import 'package:school_mate/main.dart';

Future<List<Country>> getCountries() async {
  final response = await http.get(
      Uri.parse('https://countriesnow.space/api/v0.1/countries/flag/images'));
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch countries');
  }
  final decoded = jsonDecode(response.body);
  if (decoded['error'] == true) {
    throw Exception('API returned error: ${decoded['msg']}');
  }
  final data = decoded['data'] as List<dynamic>;
  List<Country> countries = [];
  for (final country in data) {
    final name = country['name'] as String?;
    final code = country['iso2'] as String?;
    if (name != null && code != null) {
      final cleanCode = code.trim().toLowerCase();
      final flagUrl = 'https://flagcdn.com/w320/$cleanCode.png';
      countries.add(Country(name.trim(), code.trim(), Uri.parse(flagUrl)));
    }
  }

  countries.sort((Country a, Country b) => a.name.compareTo(b.name));
  return countries;
}

Future<List<SubCountryState>> getStatesOfCountry(String country) async {
  final response = await http.get(Uri.parse(
      'http://api.geonames.org/searchJSON?country=$country&featureCode=ADM1&maxRows=10&username=${const String.fromEnvironment("GEONAMES_API_USER")}'));

  if (response.statusCode != 200) {
    logger.w(response.body);
    throw Exception('Failed to fetch states');
  }
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final geonames = data['geonames'] as List<dynamic>;
  List<SubCountryState> states = geonames.map((state) {
    return SubCountryState.fromJson(state);
  }).toList();

  return states;
}

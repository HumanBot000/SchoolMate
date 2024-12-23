import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Classes/geoPolitics/Country.dart';
import '../Classes/geoPolitics/SubCountryState.dart';
import '../main.dart';

Future<List<Country>> getCountries() async {
  final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all?fields=name,flags,cca2'));
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch countries');
  }
  final data = jsonDecode(response.body) as List<dynamic>;
  List<Country> countries = [];
  for (final country in data) {
    countries.add(Country.fromJson(country));
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

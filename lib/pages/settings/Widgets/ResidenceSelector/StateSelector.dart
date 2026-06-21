import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_mate/API/externalAPIClients/geoAPIs.dart' as geo_api;
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';

/// ISO codes for German states (used to load local SVG flags)
Map<String, String> germanStatesISOCodes = {
  "Baden-Württemberg": "BW",
  "Bavaria": "BY",
  "Berlin": "BE",
  "Brandenburg": "BB",
  "Bremen": "HB",
  "Hamburg": "HH",
  "Hesse": "HE",
  "Mecklenburg-Western-Pomerania": "MV",
  "Lower-Saxony": "NI",
  "North-Rhine-Westphalia": "NW",
  "Rhineland-Palatinate": "RP",
  "Saarland": "SL",
  "Saxony": "SN",
  "Saxony-Anhalt": "ST",
  "Schleswig-Holstein": "SH",
  "Thuringia": "TH",
};

/// ISO codes for US states (abbreviations only, no images)
Map<String, String> usStates = {
  'Alabama': 'AL',
  'Alaska': 'AK',
  'Arizona': 'AZ',
  'Arkansas': 'AR',
  'California': 'CA',
  'Colorado': 'CO',
  'Connecticut': 'CT',
  'Delaware': 'DE',
  'Florida': 'FL',
  'Georgia': 'GA',
  'Hawaii': 'HI',
  'Idaho': 'ID',
  'Illinois': 'IL',
  'Indiana': 'IN',
  'Iowa': 'IA',
  'Kansas': 'KS',
  'Kentucky': 'KY',
  'Louisiana': 'LA',
  'Maine': 'ME',
  'Maryland': 'MD',
  'Massachusetts': 'MA',
  'Michigan': 'MI',
  'Minnesota': 'MN',
  'Mississippi': 'MS',
  'Missouri': 'MO',
  'Montana': 'MT',
  'Nebraska': 'NE',
  'Nevada': 'NV',
  'New Hampshire': 'NH',
  'New Jersey': 'NJ',
  'New Mexico': 'NM',
  'New York': 'NY',
  'North Carolina': 'NC',
  'North Dakota': 'ND',
  'Ohio': 'OH',
  'Oklahoma': 'OK',
  'Oregon': 'OR',
  'Pennsylvania': 'PA',
  'Rhode Island': 'RI',
  'South Carolina': 'SC',
  'South Dakota': 'SD',
  'Tennessee': 'TN',
  'Texas': 'TX',
  'Utah': 'UT',
  'Vermont': 'VT',
  'Virginia': 'VA',
  'Washington': 'WA',
  'West Virginia': 'WV',
  'Wisconsin': 'WI',
  'Wyoming': 'WY',
};

/// German state widgets (with SVG flag icons)
List<Widget> getGermanStatesWidgets(BuildContext context) {
  return germanStatesISOCodes.keys.map((state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: SvgPicture.asset(
            "assets/images/svg/flags/de/$state.svg",
            width: 30,
            height: 30,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              state,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }).toList();
}

/// U.S. state widgets (no images)
List<Widget> getUSStateWidgets(BuildContext context) {
  return usStates.keys.map((state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(32),
          child: Icon(Icons.flag), // Generic placeholder
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              state,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }).toList();
}

/// Widgets for API-fetched states of other countries
Future<List<Widget>> getStateWidgets(
    BuildContext context, String countryCode) async {
  final states = await geo_api.getStatesOfCountry(countryCode);
  return states.map((state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              state.name,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }).toList();
}

/// Main selector widget
class LocalResidenceSelector extends StatelessWidget {
  final Function onChange;
  final String selectedCountry;
  final String selectedCountryString;
  final String? selectedExactResidence;

  const LocalResidenceSelector({
    super.key,
    required this.onChange,
    required this.selectedCountry,
    required this.selectedCountryString,
    required this.selectedExactResidence,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countryCode = selectedCountry.toUpperCase();

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Where do you live?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 400,
              child: countryCode == "DE"
                  ? CarouselView.weighted(
                      onTap: (index) => onChange(germanStatesISOCodes[
                          germanStatesISOCodes.keys.toList()[index]]),
                      scrollDirection: Axis.vertical,
                      flexWeights: const [1, 2, 1],
                      children: getGermanStatesWidgets(context),
                    )
                  : countryCode == "US"
                      ? CarouselView.weighted(
                          onTap: (index) =>
                              onChange(usStates[usStates.keys.toList()[index]]),
                          scrollDirection: Axis.vertical,
                          flexWeights: const [1, 2, 1],
                          children: getUSStateWidgets(context),
                        )
                      : FutureBuilder<List<Widget>>(
                          future: getStateWidgets(context, selectedCountry),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (selectedExactResidence != "unset") {
                                  onChange("unset");
                                }
                              });
                              return const Center(
                                child: Text(
                                  "There aren't any states available for your country.",
                                ),
                              );
                            } else if (snapshot.hasData) {
                              return CarouselView.weighted(
                                onTap: (index) async {
                                  try {
                                    final states = await geo_api
                                        .getStatesOfCountry(selectedCountry);
                                    final stateCode = states[index].code;
                                    onChange(stateCode);
                                  } catch (error) {
                                    logger.e(error);
                                  }
                                },
                                scrollDirection: Axis.vertical,
                                flexWeights: const [1, 2, 1],
                                children: snapshot.data!,
                              );
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (selectedCountryString != "unset") {
                                  onChange("unset");
                                }
                              });
                              return Center(child: Text(l10n.noDataAvailable));
                            }
                          },
                        ),
            ),
            const Divider(),
            InkWell(
              onTap: () => onChange(null),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I don't live in $selectedCountryString",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.door_front_door_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

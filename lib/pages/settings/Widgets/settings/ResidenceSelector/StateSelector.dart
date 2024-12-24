// this file ended up a bit messy, but I just couldn't find a ISO 3166-2 to SVG Flag API (waisted hours looking for it) So I had two cases for germany and every other state
import 'package:app/API/externalAPIClients/geoAPIs.dart' as geo_api;
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Map<String, String> germanStates = {
  "Baden-Württemberg": "assets/images/svg/flags/de/Baden-Württemberg.svg",
  "Bavaria": "assets/images/svg/flags/de/Bavaria.svg",
  "Berlin": "assets/images/svg/flags/de/Berlin.svg",
  "Brandenburg": "assets/images/svg/flags/de/Brandenburg.svg",
  "Bremen": "assets/images/svg/flags/de/Bremen.svg",
  "Hamburg": "assets/images/svg/flags/de/Hamburg.svg",
  "Hesse": "assets/images/svg/flags/de/Hesse.svg",
  "Mecklenburg Western-Pomerania":
      "assets/images/svg/flags/de/Mecklenburg-Western-Pomerania.svg",
  "Lower-Saxony": "assets/images/svg/flags/de/Lower-Saxony.svg",
  "North-Rhine Westphalia":
      "assets/images/svg/flags/de/North-Rhine-Westphalia.svg",
  "Rhineland-Palatinate": "assets/images/svg/flags/de/Rhineland-Palatinate.svg",
  "Saarland": "assets/images/svg/flags/de/Saarland.svg",
  "Saxony": "assets/images/svg/flags/de/Saxony.svg",
  "Saxony-Anhalt":
      "assets/images/svg/flags/de/Saxony-Anhalt.svg", //todo empty image?
  "Schleswig-Holstein": "assets/images/svg/flags/de/Schleswig-Holstein.svg",
  "Thuringia": "assets/images/svg/flags/de/Thuringia.svg",
};
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

List<Widget> getGermanStatesWidgets(BuildContext context) {
  List<Widget> widgets = [];
  for (var state in germanStates.keys) {
    widgets.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(32),
        child: SvgPicture.asset(
          germanStates[state]!,
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
      )),
    ]));
  }
  return widgets;
}

Future<List<Widget>> getStateWidgets(
    BuildContext context, String countryCode) async {
  List<Widget> widgets = [];
  for (var state in await geo_api.getStatesOfCountry(countryCode)) {
    widgets.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: Align(
        alignment: Alignment.center,
        child: Text(
          state.name,
          style: const TextStyle(fontSize: 20),
        ),
      )),
    ]));
  }
  return widgets;
}

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
              child: selectedCountry.toUpperCase() == "DE"
                  ? CarouselView.weighted(
                      onTap: (index) => onChange(germanStatesISOCodes[
                          germanStates.keys.toList()[index]]),
                      scrollDirection: Axis.vertical,
                      flexWeights: const [1, 2, 1],
                      children: getGermanStatesWidgets(context))
                  : FutureBuilder<List<Widget>>(
                      future: getStateWidgets(context, selectedCountry),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          //Ensure build is finished to not raise setState() called during build
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (selectedExactResidence != "unset") {
                              onChange("unset");
                            }
                          });
                          return const Center(
                              child: Text(
                                  "There aren't any states available for your country."));
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
                          // Avoid redundant calls for empty data.
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (selectedCountryString != "unset") {
                              onChange("unset");
                            }
                          });
                          return const Center(
                              child: Text('No data available.'));
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Map<String, String> states = {
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

class ResidenceSelector extends StatelessWidget {
  final Function onChange;
  const ResidenceSelector({super.key, required this.onChange});

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
              child: CarouselView.weighted(
                onTap: (index) => onChange(states.keys.toList()[index]),
                scrollDirection: Axis.vertical,
                flexWeights: const [1, 2, 1],
                children: getGermanStatesWidgets(context),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () => onChange(false),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I don't live in Germany",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.door_front_door_outlined),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> getGermanStatesWidgets(BuildContext context) {
  List<Widget> widgets = [];
  for (var state in states.keys) {
    widgets.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(32),
        child: SvgPicture.asset(
          states[state]!,
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

List<Widget> getGermanStatesWidgetsWithHeroFlag(BuildContext context) {
  List<Widget> widgets = [];
  for (var state in states.keys) {
    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  states[state]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
                Positioned(
                  bottom: 12,
                  child: Container(
                    color: Colors.black54.withValues(alpha: 0.6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: Text(
                      state,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return widgets;
}

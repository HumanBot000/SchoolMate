import 'package:app/API/externalAPIClients/geoAPIs.dart' as geo_api;
import 'package:app/Classes/geoPolitics/Country.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResidenceSelector extends StatefulWidget {
  final Function onChange;
  final Country? preSelectedCountry;

  const ResidenceSelector(
      {super.key, required this.onChange, required this.preSelectedCountry});

  @override
  State<ResidenceSelector> createState() => _ResidenceSelectorState();
}

class _ResidenceSelectorState extends State<ResidenceSelector> {
  final CarouselController _controller = CarouselController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToSelectedCountry();
  }

  @override
  void didUpdateWidget(covariant ResidenceSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preSelectedCountry != oldWidget.preSelectedCountry) {
      _scrollToSelectedCountry();
    }
  }

  Future<void> _scrollToSelectedCountry({int retries = 0}) async {
    if (retries > 5) {
      return;
    }
    if (widget.preSelectedCountry == null) {
      return;
    }
    int index = await geo_api
        .getCountries()
        .then((countries) => countries.indexOf(widget.preSelectedCountry!));
    if (index == -1) {
      return;
    }
    index *=
        100; // This value is derived from the height of each CarouselView element - some calculated padding (IDK if 100 is the correct value but it seems fine for most screen resolutions)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _controller.jumpTo(index.toDouble());
        await _controller.animateTo(index.toDouble(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        logger.i("Scrolled to ${index.toDouble()}");
      } catch (e) {
        logger.e(e);
        await _scrollToSelectedCountry(retries: retries + 1);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              child: FutureBuilder<List<Country>>(
                future: geo_api.getCountries(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return Scrollbar(
                      controller: _scrollController,
                      child: CarouselView.weighted(
                        controller: _controller,
                        onTap: (index) {
                          widget.onChange(snapshot.data![index]);
                          _controller.jumpTo(index.toDouble());
                        },
                        scrollDirection: Axis.vertical,
                        flexWeights: const [1, 2, 1],
                        // Main Object is twice as big as previous and next
                        children: getCountryWidgets(context, snapshot.data!),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available.'));
                  }
                },
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

List<Widget> getCountryWidgets(BuildContext context, List<Country> countries) {
  List<Widget> widgets = [];
  for (var country in countries) {
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
                SvgPicture.network(
                  country.flag.toString(),
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
                      country.name,
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

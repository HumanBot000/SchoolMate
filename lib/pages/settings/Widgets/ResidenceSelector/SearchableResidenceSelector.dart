import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_mate/API/externalAPIClients/geoAPIs.dart' as geo_api;
import 'package:school_mate/Classes/geoPolitics/Country.dart';
import 'package:school_mate/main.dart';

import 'StateSelector.dart';

class SearchableResidenceSelector extends StatefulWidget {
  final Function onChange;
  final Country? preSelectedCountry;

  const SearchableResidenceSelector({
    super.key,
    required this.onChange,
    required this.preSelectedCountry,
  });

  @override
  State<SearchableResidenceSelector> createState() =>
      _SearchableResidenceSelectorState();
}

class _SearchableResidenceSelectorState
    extends State<SearchableResidenceSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterCountries();
    });
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final countries = await geo_api.getCountries();
      setState(() {
        _allCountries = countries;
        _filteredCountries = countries;
        _isLoading = false;
      });
    } catch (e) {
      logger.e("Error loading countries: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCountries() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredCountries = _allCountries;
      });
      return;
    }

    setState(() {
      _filteredCountries = _allCountries
          .where((country) => country.name.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Where do you live?",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SearchBar(
              controller: _searchController,
              hintText: "Search for a country...",
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
              ],
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              elevation: WidgetStateProperty.all<double>(4.0),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCountries.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "No countries found matching '$_searchQuery'",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = _filteredCountries[index];
                            return CountryListItem(
                              country: country,
                              onTap: () {
                                widget.onChange(country);
                              },
                              isSelected: widget.preSelectedCountry?.code ==
                                  country.code,
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class CountryListItem extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;
  final bool isSelected;

  const CountryListItem({
    super.key,
    required this.country,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: isSelected ? 8 : 2,
        color:
            isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 40,
                  child: SvgPicture.network(
                    country.flag.toString(),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    country.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchableStateSelector extends StatefulWidget {
  final Function onChange;
  final String selectedCountry;
  final String selectedCountryString;
  final String? selectedExactResidence;

  const SearchableStateSelector({
    super.key,
    required this.onChange,
    required this.selectedCountry,
    required this.selectedCountryString,
    required this.selectedExactResidence,
  });

  @override
  State<SearchableStateSelector> createState() =>
      _SearchableStateSelectorState();
}

class _SearchableStateSelectorState extends State<SearchableStateSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allStates = [];
  List<dynamic> _filteredStates = [];
  bool _isLoading = true;
  String _searchQuery = "";
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterStates();
    });
  }

  Future<void> _loadStates() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final countryCode = widget.selectedCountry.toUpperCase();

      if (countryCode == "DE") {
        // For Germany, use the predefined states
        setState(() {
          _allStates = germanStatesISOCodes.keys.toList();
          _filteredStates = _allStates;
          _isLoading = false;
        });
      } else if (countryCode == "US") {
        // For US, use the predefined states
        setState(() {
          _allStates = usStates.keys.toList();
          _filteredStates = _allStates;
          _isLoading = false;
        });
      } else {
        final states = await geo_api.getStatesOfCountry(widget.selectedCountry);
        setState(() {
          _allStates = states;
          _filteredStates = states;
          _isLoading = false;
        });
      }
    } catch (e) {
      logger.e("Error loading states: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _filterStates() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredStates = _allStates;
      });
      return;
    }

    setState(() {
      if (widget.selectedCountry.toUpperCase() == "DE" ||
          widget.selectedCountry.toUpperCase() == "US") {
        _filteredStates = _allStates
            .where((state) =>
                state.toString().toLowerCase().contains(_searchQuery))
            .toList();
      } else {
        _filteredStates = _allStates
            .where((state) => state.name.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadStates();
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important: Set to min
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Select your state/province",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SearchBar(
              controller: _searchController,
              hintText: "Search for a state...",
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
              ],
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              elevation: MaterialStateProperty.all<double>(4.0),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              "There aren't any states available for your country.",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                widget.onChange("unset");
                              },
                              child: const Text(
                                  "Continue without state selection"),
                            ),
                          ],
                        ),
                      )
                    : _filteredStates.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "No states found matching '$_searchQuery'",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 280),
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _filteredStates.length,
                              itemBuilder: (context, index) {
                                final state = _filteredStates[index];
                                final countryCode =
                                    widget.selectedCountry.toUpperCase();
                                String stateCode;
                                String stateName;

                                if (countryCode == "DE") {
                                  stateName = state;
                                  stateCode = germanStatesISOCodes[state]!;
                                } else if (countryCode == "US") {
                                  stateName = state;
                                  stateCode = usStates[state]!;
                                } else {
                                  stateName = state.name;
                                  stateCode = index.toString();
                                }

                                return StateListItem(
                                  stateName: stateName,
                                  stateCode: stateCode,
                                  countryCode: countryCode,
                                  onTap: () {
                                    widget.onChange(stateCode);
                                  },
                                  isSelected: widget.selectedExactResidence ==
                                      stateCode,
                                );
                              },
                            ),
                          ),
            const Divider(),
            InkWell(
              onTap: () => widget.onChange(null),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I don't live in ${widget.selectedCountryString}",
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

class StateListItem extends StatelessWidget {
  final String stateName;
  final String stateCode;
  final String countryCode;
  final VoidCallback onTap;
  final bool isSelected;

  const StateListItem({
    super.key,
    required this.stateName,
    required this.stateCode,
    required this.countryCode,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: isSelected ? 8 : 2,
        color:
            isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                if (countryCode == "DE")
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 40,
                      height: 30,
                      child: SvgPicture.asset(
                        "assets/images/svg/flags/de/$stateName.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 40,
                      height: 30,
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    stateName,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

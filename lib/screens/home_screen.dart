import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/api_service.dart';
import '../widgets/country_card.dart';
import 'country_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Country) onCountryTap;
  final Function(Country) onFavoriteToggle;
  final List<Country> favoriteCountries;

  const HomeScreen({
    super.key,
    required this.onCountryTap,
    required this.onFavoriteToggle,
    required this.favoriteCountries,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Country> _countries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = true;
  Map<String, List<Country>> _groupedCountries = {};
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isSuggestionsOpen = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _apiService.getAllCountries();
      // Sort countries by common name
      countries.sort((a, b) => a.name.compareTo(b.name));
      setState(() {
        _countries = countries;
        _filteredCountries = countries;
        _groupedCountries = _groupCountries(countries);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading countries: $e')),
      );
    }
  }

  Map<String, List<Country>> _groupCountries(List<Country> countries) {
    final grouped = <String, List<Country>>{};
    for (var country in countries) {
      final letter = country.name[0].toUpperCase();
      if (!grouped.containsKey(letter)) {
        grouped[letter] = [];
      }
      grouped[letter]!.add(country);
    }
    return Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _hideOverlay();
        _filteredCountries = _countries;
        _groupedCountries = _groupCountries(_countries);
      } else {
        _filteredCountries = _countries
            .where((country) =>
                country.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _groupedCountries = _groupCountries(_filteredCountries);

        // Update suggestions immediately
        _hideOverlay(); // Remove existing overlay
        if (_filteredCountries.isNotEmpty) {
          _showSuggestions(); // Show new suggestions
        }
      }
    });
  }

  void _showSuggestions() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 60.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredCountries.length > 5
                    ? 5
                    : _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  return ListTile(
                    leading: const Icon(Icons.search, size: 20),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      country.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      _searchController.text = country.name;
                      _searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: country.name.length),
                      );
                      _filterCountries(country.name);
                      _hideOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() => _isSuggestionsOpen = true);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isSuggestionsOpen = false);
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              //color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CompositedTransformTarget(
              link: _layerLink,
              child: TextField(
                controller: _searchController,
                onChanged: _filterCountries,
                onSubmitted: (_) => _hideOverlay(),
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterCountries('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orange),
                  ),
                  filled: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _groupedCountries.length * 2,
                    itemBuilder: (context, index) {
                      if (index.isEven) {
                        final letter =
                            _groupedCountries.keys.elementAt(index ~/ 2);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      } else {
                        final letter =
                            _groupedCountries.keys.elementAt(index ~/ 2);
                        final countriesInGroup = _groupedCountries[letter]!;
                        return Column(
                          children: countriesInGroup
                              .map((country) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: CountryCard(
                                      country: country,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CountryDetailsScreen(
                                                    country: country),
                                          ),
                                        );
                                      },
                                      isFavorite: widget.favoriteCountries
                                          .contains(country),
                                      onFavoritePressed: () {
                                        widget.onFavoriteToggle(country);
                                        setState(
                                            () {}); // Trigger rebuild to update UI
                                      },
                                    ),
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

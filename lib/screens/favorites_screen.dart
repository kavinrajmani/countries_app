import 'package:flutter/material.dart';
import '../models/country.dart';
import '../widgets/country_card.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Country> favoriteCountries;
  final Function(Country) onCountryTap;
  final Function(Country) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favoriteCountries,
    required this.onCountryTap,
    required this.onFavoriteToggle,
  });

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.favoriteCountries.isEmpty
          ? const Center(
              child: Text('No favorite countries yet'),
            )
          : ListView.builder(
              itemCount: widget.favoriteCountries.length,
              itemBuilder: (context, index) {
                final country = widget.favoriteCountries[index];
                return CountryCard(
                  country: country,
                  onTap: () => widget.onCountryTap(country),
                  isFavorite: true,
                  onFavoritePressed: () => widget.onFavoriteToggle(country),
                );
              },
            ),
    );
  }
}

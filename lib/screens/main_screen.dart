import 'package:countries_app/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/country.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'country_details_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String _favoritesKey = 'favorites';
  int _selectedIndex = 0;
  final List<Country> _favoriteCountries = [];

  final _homeScreenKey = GlobalKey();
  final _favoritesScreenKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Initialize screens as final
  List<Widget> get screens => [
        HomeScreen(
          key: _homeScreenKey,
          onCountryTap: _handleCountryTap,
          onFavoriteToggle: _toggleFavorite,
          favoriteCountries: _favoriteCountries,
        ),
        FavoritesScreen(
          key: _favoritesScreenKey,
          favoriteCountries: _favoriteCountries,
          onCountryTap: _handleCountryTap,
          onFavoriteToggle: _toggleFavorite,
        ),
      ];

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    setState(() {
      _favoriteCountries.clear();
      _favoriteCountries.addAll(
        favoritesJson.map((json) => Country.fromJson(jsonDecode(json))),
      );
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favoriteCountries
        .map((country) => jsonEncode(country.toJson()))
        .toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  void _toggleFavorite(Country country) {
    setState(() {
      if (_favoriteCountries.contains(country)) {
        _favoriteCountries.remove(country);
      } else {
        _favoriteCountries.add(country);
      }
      _saveFavorites();
    });
  }

  void _handleCountryTap(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailsScreen(country: country),
      ),
    );
  }

  void _onTabChange(int newIndex) {
    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (_selectedIndex == 0) {
          final shouldPop =
              await NavigationHelper.showExitConfirmationDialog(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          setState(() {
            _selectedIndex = _selectedIndex - 1;
          });
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabChange,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}

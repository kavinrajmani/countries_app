import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Image.network(
          country.flagUrl,
          width: 50,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.flag, size: 50),
        ),
        title: Text(
          country.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          country.capital,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoritePressed,
        ),
        onTap: onTap,
      ),
    );
  }
}

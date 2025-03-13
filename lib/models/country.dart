class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final List<String> languages;
  final String flagUrl;
  final List<String> currencies;
  final List<String> borders;
  final double area; // Add area property
  final List<String> timezones; // Add timezones property
  final bool isFavorite;

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.languages,
    required this.flagUrl,
    required this.currencies,
    required this.borders,
    required this.area, // Add to constructor
    required this.timezones, // Add to constructor
    this.isFavorite = false,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? '',
      officialName: json['name']['official'] ?? '',
      capital: (json['capital'] as List?)?.first ?? '',
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      population: json['population'] ?? 0,
      languages: (json['languages'] as Map<String, dynamic>?)
              ?.values
              .cast<String>()
              .toList() ??
          [],
      flagUrl: json['flags']['png'] ?? '',
      currencies: (json['currencies'] as Map<String, dynamic>?)
              ?.values
              .map((curr) => '${curr['name']} (${curr['symbol']})')
              .cast<String>()
              .toList() ??
          [],
      borders: (json['borders'] as List?)?.cast<String>() ?? [],
      area: (json['area'] ?? 0).toDouble(),
      timezones: List<String>.from(json['timezones'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {
        'common': name,
        'official': officialName,
      },
      'capital': [capital],
      'region': region,
      'subregion': subregion,
      'population': population,
      'languages': Map.fromIterables(
        List.generate(languages.length, (i) => 'lang$i'),
        languages,
      ),
      'flags': {
        'png': flagUrl,
      },
      'currencies': currencies.isEmpty
          ? {}
          : Map.fromIterables(
              List.generate(currencies.length, (i) => 'cur$i'),
              currencies.map((c) {
                final parts = c.split(' ');
                final symbol = parts.last.replaceAll(RegExp(r'[\(\)]'), '');
                final name = parts.take(parts.length - 1).join(' ');
                return {'name': name, 'symbol': symbol};
              }),
            ),
      'borders': borders,
      'area': area,
      'timezones': timezones,
      'isFavorite': isFavorite,
    };
  }

  Country copyWith({bool? isFavorite}) {
    return Country(
      name: name,
      officialName: officialName,
      capital: capital,
      region: region,
      subregion: subregion,
      population: population,
      languages: languages,
      flagUrl: flagUrl,
      currencies: currencies,
      borders: borders,
      area: area,
      timezones: timezones,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

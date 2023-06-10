import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final String name;
  final String state;
  final String country;
  final bool capital;
  final int population;
  final List<String>? regions;

  City({
    required this.name,
    required this.state,
    required this.country,
    required this.capital,
    required this.population,
    required this.regions,
  });

  factory City.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return City(
      name: data?['name'],
      state: data?['state'],
      country: data?['country'],
      capital: data?['capital'],
      population: data?['population'],
      regions:
          data?['regions'] is Iterable ? List.from(data?['regions']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (state != null) "state": state,
      if (country != null) "country": country,
      if (capital != null) "capital": capital,
      if (population != null) "population": population,
      if (regions != null) "regions": regions,
    };
  }
}
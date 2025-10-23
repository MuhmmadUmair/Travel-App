// lib/provider/place_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/services/travel_advicer_service.dart';
import '../models/place_model.dart';

class PlaceProvider with ChangeNotifier {
  List<PlaceModel> _places = [];
  bool _isLoading = false;
  String? _errorMessage;

  // simple debounce timer for search
  Timer? _debounceTimer;
  String? _lastQuery; // avoid refetching same query

  static const String _favKey = 'favourite_places_v1';

  List<PlaceModel> get places => _places;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PlaceModel> get favourites =>
      _places.where((p) => p.isFavourite).toList();

  // initial loader
  Future<void> loadInitialData() async {
    await fetchPlaces('Lahore');
    await _loadFavouritesFromPrefs();
  }

  // Fetch places with debounce. If call is repeated within [debounceMs], previous
  // call is cancelled. Default debounce = 400ms.
  void searchPlacesDebounced(
    String query, {
    int limit = 15,
    int debounceMs = 400,
  }) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: debounceMs), () {
      fetchPlaces(query, limit: limit);
    });
  }

  // The main fetch method (cancelling debounce)
  Future<void> fetchPlaces(String query, {int limit = 15}) async {
    // Prevent duplicate fetch for same query in a short time
    if (query.trim().isEmpty) return;
    if (_lastQuery != null && _lastQuery == query && !_isLoading) {
      // same query, do nothing
      return;
    }

    // remember last query
    _lastQuery = query;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await TravelAdvisorService.searchLocations(
        query,
        limit: limit,
      );

      // assign results (replace previous list)
      _places = results;

      // restore favourites from local prefs
      await _loadFavouritesFromPrefs();
    } catch (e, st) {
      _errorMessage = 'Failed to load places: $e';
      _places = [];
      if (kDebugMode) {
        // print stack in debug for easier troubleshooting
        debugPrint('fetchPlaces error: $e\n$st');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Favourites handling
  void toggleFavourite(PlaceModel place) {
    final index = _places.indexOf(place);
    if (index == -1) return;
    _places[index].isFavourite = !_places[index].isFavourite;
    notifyListeners();
    _saveFavouritesToPrefs();
  }

  Future<void> _saveFavouritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final favNames = _places
        .where((p) => p.isFavourite)
        .map((p) => p.name)
        .toList();
    await prefs.setStringList(_favKey, favNames);
  }

  Future<void> _loadFavouritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_favKey) ?? [];
    if (_places.isNotEmpty) {
      for (var p in _places) {
        p.isFavourite = saved.contains(p.name);
      }
      notifyListeners();
    }
  }

  // cleanup
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

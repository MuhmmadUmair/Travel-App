import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/pages/favourite_screen.dart';
import '../provider/place_provider.dart';
import '../widgets/header_section.dart';
import '../widgets/search_box.dart';
import '../widgets/place_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController(
    text: 'Lahore',
  );

  @override
  void initState() {
    super.initState();
    // initial load handled by provider.loadInitialData called in main.dart provider creation
  }

  void _searchPlaces() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<PlaceProvider>().fetchPlaces(query);
    }
  }

  void _showFavourites() {
    final favourites = context.read<PlaceProvider>().favourites;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FavouriteScreen(favourites: favourites),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlaceProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Places'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: _showFavourites,
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? Center(child: Text(provider.errorMessage!))
          : Column(
              children: [
                HeaderSection(size: size),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: SearchBox(
                    controller: _searchController,
                    onSearch: _searchPlaces,
                  ),
                ),
                Expanded(
                  child: provider.places.isEmpty
                      ? const Center(child: Text('No places found.'))
                      : ListView.builder(
                          itemCount: provider.places.length,
                          itemBuilder: (ctx, i) =>
                              PlaceCard(place: provider.places[i]),
                        ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

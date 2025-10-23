import 'package:flutter/material.dart';
import 'package:travel_app/widgets/place_card.dart';
import '../models/place_model.dart';

class FavouriteScreen extends StatelessWidget {
  final List<PlaceModel> favourites;
  const FavouriteScreen({super.key, required this.favourites});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text('Favourites', textAlign: TextAlign.center),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: favourites.isEmpty
              ? const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'No favourite places yet ❤️',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: favourites.length,
                  itemBuilder: (ctx, i) => PlaceCard(place: favourites[i]),
                ),
        ),
      ),
    );
  }
}

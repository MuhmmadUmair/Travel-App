import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/pages/home_screen.dart';
import 'provider/place_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlaceProvider()..loadInitialData(),
      child: MaterialApp(
        title: 'Travel App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Lato'),
        home: const HomeScreen(),
      ),
    );
  }
}

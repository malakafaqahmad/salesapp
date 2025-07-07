import 'package:flutter/material.dart';
import 'package:mobileapp/screens/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- This is essential
  runApp(const TelSaleApp());
}

class TelSaleApp extends StatelessWidget {
  const TelSaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TelSale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(), // Set your HomePage as the starting point
      // Optionally add routes here:
      routes: {
        '/home': (context) => const HomeScreen(),
        // Add more screens like '/sales': (_) => SalesPage(),
      },
    );
  }
}

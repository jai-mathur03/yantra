import 'package:flutter/material.dart';
import 'package:yantra_blackspace/screens/data_screen.dart';
import 'package:yantra_blackspace/screens/home_screen.dart';
import 'package:yantra_blackspace/screens/profile_screen.dart';
import 'package:yantra_blackspace/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart City Solar App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/data': (context) => DataScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

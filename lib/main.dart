import 'package:app/pages/userAuth/userAuthentication.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A7BD5),
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF2B2B2B),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Colors.white, fontSize: 30),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2B2B2B),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          centerTitle: true,
        ),
      ),
      home: const AuthenticationPage(),
    );
  }
}

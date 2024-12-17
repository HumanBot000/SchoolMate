import 'package:app/pages/userAuth/userAuthentication.dart';
import 'package:app/setup/supabase.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late final Supabase supabaseClient;
final logger = Logger();
late final SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  prefs = await SharedPreferences.getInstance();
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
          iconTheme: IconThemeData(color: Color(0xFF3A7BD5)),
          titleTextStyle: TextStyle(color: Color(0xFF3A7BD5), fontSize: 20),
          centerTitle: true,
        ),
      ),
      home: const AuthenticationPage(),
    );
  }
}

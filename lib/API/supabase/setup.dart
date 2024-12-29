import 'package:school_mate/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

Future<void> initializeSupabase() async {
  supabaseClient = await Supabase.initialize(
    url: "https://nopekgcnoeblprvjjpvv.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcGVrZ2Nub2VibHBydmpqcHZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQwMTU4MzAsImV4cCI6MjA0OTU5MTgzMH0.Ogd1g9yMwaMD5yVhniTP7poxsHQ7c27GkXgFS9zzZi8", //public key
  );
}

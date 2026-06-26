class AppConstants {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://nopekgcnoeblprvjjpvv.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcGVrZ2Nub2VibHBydmpqcHZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQwMTU4MzAsImV4cCI6MjA0OTU5MTgzMH0.Ogd1g9yMwaMD5yVhniTP7poxsHQ7c27GkXgFS9zzZi8',
  );
}

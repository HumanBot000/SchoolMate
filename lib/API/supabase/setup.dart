import 'package:school_mate/main.dart';
import 'package:school_mate/util/constants.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

Future<void> initializeSupabase() async {
  supabaseClient = await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
}

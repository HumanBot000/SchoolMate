import 'package:app/API/supabase/auth/userData.dart';
import 'package:app/Classes/geoPolitics/Country.dart';
import 'package:app/main.dart';

Future<void> updateUserSettings(
    Country residenceCountry, String? residence, String gradingSystem) async {
  // residence is already the code -> makes it easier to work with
  if (residence == "unset") {
    residence = null; //convert back for DB integrity
  }
  try {
    //Insert or Update
    await supabaseClient.client.from("user_settings").upsert({
      "user_id": await getUserID(),
      "residence": residence,
      "residence_country": residenceCountry.code,
      "grading_system": gradingSystem
    });
  } on Exception catch (e) {
    logger.e(e);
  }
}

Future<Map<String, dynamic>> getUserSettings() async =>
    await supabaseClient.client
        .from("user_settings")
        .select()
        .eq("user_id", await getUserID())
        .single();

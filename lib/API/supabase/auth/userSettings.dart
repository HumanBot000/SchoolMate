import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/geoPolitics/Country.dart';
import 'package:school_mate/main.dart';

@Deprecated("Use forceUpdateUserSettings() instead")
Future<void> updateUserSettings(
    Country residenceCountry, String? residence) async {
  // residence is already the code -> makes it easier to work with it

  // no idea what I did here... best to deprecate it
  if (residence == "unset") {
    residence = null; //convert back for DB integrity
  }
  try {
    //Insert or Update
    await supabaseClient.client.schema("settings").from("residence").upsert({
      "user_id": await getUserID(),
      "residence": residence,
      "residence_country": residenceCountry.code,
    }).eq("user_id", await getUserID());
  } on Exception catch (e) {
    logger.e(e);
  }
}

Future<Map<String, dynamic>?> getUserSettings() async {
  final response = await supabaseClient.client
      .schema("settings")
      .from("residence")
      .select()
      .eq("user_id", await getUserID());

  if (response.isEmpty) {
    return null;
  }
  return response.single;
}

/// Forces the user settings to be updated (not upserted)
Future<void> forceUpdateUserSettings(
    Country? residenceCountry, String? residence, String? gradingSystem) async {
  // implement old logic from deprecated function
  if (residence != "unset" && residence != null) {
    await supabaseClient.client.schema("settings").from("residence").update({
      "residence": residence,
    }).eq("user_id", await getUserID());
  }

  if (residenceCountry != null) {
    await supabaseClient.client.schema("settings").from("residence").update({
      "residence_country": residenceCountry.code,
    }).eq("user_id", await getUserID());
  }

  if (gradingSystem != null) {
    await supabaseClient.client.schema("settings").from("residence").update({
      "grading_system": gradingSystem,
    }).eq("user_id", await getUserID());
  }
}

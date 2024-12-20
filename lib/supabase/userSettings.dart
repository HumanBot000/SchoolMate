import 'package:app/main.dart';
import 'package:app/util/userData.dart';

Future<void> updateUserSettings(dynamic residence, String gradingSystem) async {
  dynamic residence_county;
  if (residence != false) {
    residence_county = "de";
  }
  logger.v(await supabaseClient.client.from("user_settings").select());
  try {
    //Insert or Update
    await supabaseClient.client.from("user_settings").insert({
      "user_id": await getUserID(),
      "residence": residence.toString(),
      "residence_country": residence_county,
      "grading_system": gradingSystem
    });
  } on Exception catch (e) {
    logger.e(e);
  }
}

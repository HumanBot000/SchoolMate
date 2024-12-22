import 'package:app/main.dart';
import 'package:app/supabase/userData.dart';

Future<void> updateUserSettings(dynamic residence, String gradingSystem) async {
  Map<String, String> shortStateNames = {
    "Baden-Württemberg": "BW",
    "Bavaria": "BY",
    "Berlin": "BE",
    "Brandenburg": "BB",
    "Bremen": "HB",
    "Hamburg": "HH",
    "Hesse": "HE",
    "Mecklenburg-Western-Pomerania": "MV",
    "Lower-Saxony": "NI",
    "North-Rhine-Westphalia": "NW",
    "Rhineland-Palatinate": "RP",
    "Saarland": "SL",
    "Saxony": "SN",
    "Saxony-Anhalt": "ST",
    "Schleswig-Holstein": "SH",
    "Thuringia": "TH",
  };
  dynamic residenceCounty;
  if (residence != false) {
    residenceCounty = "de";
  }
  try {
    //Insert or Update
    await supabaseClient.client.from("user_settings").upsert({
      "user_id": await getUserID(),
      "residence": shortStateNames[residence],
      "residence_country": residenceCounty,
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

import '../main.dart';

String getUserName() =>
    supabaseClient.client.auth.currentUser!.userMetadata!['username'] as String;

Future<String> getUserID() async => supabaseClient.client.auth.currentUser!.id;

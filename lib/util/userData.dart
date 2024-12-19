import '../main.dart';

String getUserName() {
  return supabaseClient.client.auth.currentUser!.userMetadata!['username']
      as String;
}

import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class ApiKeyRepository {
  static const String _apiKey = "api_key";
  final rxPrefs = RxSharedPreferences.getInstance();

  Stream<String> getApi() => rxPrefs
      .getStringStream(_apiKey)
      .where((event) => event != null)
      .map((event) => event!);

  setApi(String apiKey) async {
    await rxPrefs.setString(_apiKey, apiKey);
  }
}

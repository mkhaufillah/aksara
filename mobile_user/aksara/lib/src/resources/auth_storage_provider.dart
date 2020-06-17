import 'package:aksara/src/global_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' show Client;

class AuthStorageProvider {
  final Client client = Client();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<String> getToken() async {
    String token = await storage.read(key: GlobalData.KEY_TOKEN_AUTH);
    return token;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: GlobalData.KEY_TOKEN_AUTH);
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: GlobalData.KEY_TOKEN_AUTH, value: token);
  }

  Future<bool> hasToken() async {
    String value = await storage.read(key: GlobalData.KEY_TOKEN_AUTH);
    if (value != null && value.isNotEmpty)
      return true;
    else
      return false;
  }
}

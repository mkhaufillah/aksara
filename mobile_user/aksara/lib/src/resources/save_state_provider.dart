import 'package:aksara/src/global_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SaveStateProvider {
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<void> persistState(String hasReadyStart) async {
    await storage.write(key: GlobalData.KEY_STATE, value: hasReadyStart);
  }

  Future<bool> hasStateTutorial() async {
    String value = await storage.read(key: GlobalData.KEY_STATE);
    if (value != null && value.isNotEmpty)
      return true;
    else
      return false;
  }
}

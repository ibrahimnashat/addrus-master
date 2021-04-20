
import 'session_manager.dart';

class ApiUtils {
  final SessionManager sessionManager;
  ApiUtils(this.sessionManager);
  Map<String, String> get headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
     'Authorization': "Bearer ${sessionManager.getAccessToken()}",
    };
  }

}

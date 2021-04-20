import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/user_constants.dart';

class SessionManager {
  final SharedPreferences prefs;

  SessionManager(this.prefs);

  String getTestData() {
    return prefs.getString("TEST");
  }

  void setTestData(String data) {
    prefs.setString("TEST", data);
  }

//  ------------
  String getValue(String key) {
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    } else {
      return "";
    }
  }

  setValue(String key, String value) {
    prefs.setString(key, value);
  }

  deleteValue(String key) {
    prefs.remove(key);
  }

//  user
  UserData getUser() {
    if (prefs.containsKey(UserConstants.USER_DATA)) {
      var userString = prefs.getString(UserConstants.USER_DATA);
      return UserData.decodedJson(userString);
    } else {
      return null;
    }
  }

  setUser(LoginResponse response) {
    String userString = response.user.encodedJson();
    setValue(UserConstants.USER_DATA, userString);
    setValue(UserConstants.ACCESS_TOKEN, response.access_token);
    setValue(UserConstants.USER_LOGGED, "true");
  }

  deleteUser() {
    deleteValue(UserConstants.USER_DATA);
    deleteValue(UserConstants.USER_LOGGED);
    deleteValue(UserConstants.LOGIN_PASSWORD);
    deleteValue(UserConstants.LOGIN_EMAIL);
    deleteValue(UserConstants.PROVIDER_ID);
    deleteValue(UserConstants.PROVIDER_NAME);
    deleteValue(UserConstants.ACCESS_TOKEN);
  }

  String getAccessToken() {
    if (getValue(UserConstants.USER_LOGGED).isNotEmpty) {
      print("Token Length2: ${getValue(UserConstants.ACCESS_TOKEN).length}") ;
      return getValue(UserConstants.ACCESS_TOKEN);
    } else {
      return null;
    }
  }

//  --------------

}

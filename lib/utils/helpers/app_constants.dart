import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

class AppConstants {
  static const String APP_NAME = "Adrus";

  static const String EMAIL_REGEX =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String PASSWORD_REGEX =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static const String MOBILE_CODE_REGEX = r'^[+][0-9]{1,6}$';
  static const String MOBILE_REGEX = r'^[0-9]{10,20}$';

  static const String SCREEN_SEARCH = "SCREEN_SEARCH";
  static const String SCREEN_WALLET = "SCREEN_WALLET";

  static DateFormat FORMAT_YMD = intl.DateFormat('yyyy-MM-dd');
  static DateFormat FORMAT_DMY = intl.DateFormat('dd/MM/yyyy');
  static const String APP_BASE_URL = "APP_BASE_URL";
  static const String MY_COURSES = "MY_COURSES";
  static const String OFFLINE_COURSES = "OFFLINE_COURSES";
  static const String DOWNLOADED_VIDEOS_NAMES = "DOWNLOADED_COURSES";
  static const String DOWNLOADED_COURSES_CONTENT = "DOWNLOADED_COURSES_CONTENT";

  static const String HORIZONTAL = "HORIZONTAL";
  static const String VERTICAL = "VERTICAL";

  static const String WHATS_PHONE = "+218 92-0118778"; //"+218913236503" ;

  static const String STATUS_PASS = "pass";
  static const String STATUS_FAIL = "fail";
  static const String STATUS_FAIL_TIME = "time";
  static const String STATUS_FAIL_MARK = "pass_mark";

  static const String ErrorMsg = "حدث خطأ";
}

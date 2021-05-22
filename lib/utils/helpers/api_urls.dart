class Urls {
  static const String BASE_URL =
      "https://addrus.com/api/v3/"; //"http://addrus.com/api/v3/"; //"https://addrus.xyz/z/api/v3/" ;//"https://adrustesting.xyz/api/v2/";
  //-----
  static String LOGIN = "${BASE_URL}student/login";
  static String REGISTER = "${BASE_URL}register";
  static String LOGOUT = "${BASE_URL}student/logout";
  static String EDIT_PROFILE = "${BASE_URL}student/update";
  static String FORGET_PASSWORD =
      "${BASE_URL}password/create"; //forgotpassword";

  static const String HOME_SLIDER = "${BASE_URL}student/home"; //sliders";
  static const String CATEGORIES = "${BASE_URL}getcategories";
  static const String ALL_COURSES =
      "${BASE_URL}student/courses"; //enrollmentCourses";
  static const String SINGLE_COURSE = "${BASE_URL}singleCourse/";
  static const String CATEGORY_COURSES = "${BASE_URL}catCourses/";
  static const String ADD_FAVORITE = "${BASE_URL}wishlistStore";
  static const String DELETE_FAVORITE = "${BASE_URL}deleteWishlist/";
  static const String SUPPORT = "${BASE_URL}support";
  static const String ANSWER_QUESTION = "${BASE_URL}student/quizDone";
}

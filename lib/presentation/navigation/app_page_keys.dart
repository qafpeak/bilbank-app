class AppPageKeys {
  AppPageKeys._();


  ///[HOME_MODULE]
  static const home = '/home';

  static const quiz = '/quiz';
  static const quizPath = '$home/$quiz';

  static const rules = 'rules';
  static const rulesPath = '$home/$rules';

  static const notifications='notifications';
  static const notificationsPath = '$home/$notifications';



  ///[PROFILE_MODULE]
  static const profile = '/profile';
  static const settings = 'settings';
  static const settingsPath = '$profile/$settings';

  static const editProfile = 'edit_profile';
  static const editProfilePath = '$settingsPath/$editProfile';

  static const reportIssue = 'report_issue';
  static const reportIssuePath = '$settingsPath/$reportIssue';

  ///[AUTH_MODULE]
  static const login = '/login';
  static const registerAccount = 'register_account';
  static const registerAccuntPath = '$login/$registerAccount';
  
  ///[STORE_MODULE]
  static const diamond= '/diamond';
  static const wheel= '/wheel';







  

}

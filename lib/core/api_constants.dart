class ApiConstants {
  ApiConstants._();
  static const String baseUrl = "http://192.168.0.31:3000";
  static const String apiPath = "/api";

  static const String registerUserAccount = '$apiPath/users/register';
  static const String loginUserAccount = '$apiPath/users/login';
  static const String getUserProfile = '$apiPath/users/me';
  static const String updateUserAvatar = '$apiPath/users/avatar';
  static const String getAvatarList = '$apiPath/users/avatars';

  static const String room = 'rooms';
  static const String roomPath = '$apiPath/$room';

  static const String showRoomPath = '$apiPath/$room/showRoom';
  static const String reserveRoomPath = '$apiPath/$room/reserveRoom';
  static const String joinRoomPath = '$apiPath/$room/joinRoom';
  static const String roomRewardsPath = '$apiPath/$room/rewards';

  
  static const String notification = 'notification';
  static const String notificationPath = '$apiPath/$notification';
  static const String getNotificationCount = '$notificationPath/getNotificationCount';


  
  
}

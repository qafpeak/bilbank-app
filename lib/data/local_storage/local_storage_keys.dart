enum LocalStorageKeys {
  accessToken,
  refreshToken,
  firstPage,
  rememberMeEmail,
  rememberMePassword,
  rememberCheck,
  userId,
  userEmail,
  userName,
  userPhone,
  userTCNo,
  userProfileImageUrl,
  isDarkMode,
  firstName,
  lastName,
  userBalance,
  userTrivaBalance,
  userAvatarId,
}


extension KeyName on LocalStorageKeys {
  String get key => 'local_storage_key.$name'; // tek bir isimlendirme standardı
}
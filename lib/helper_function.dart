import 'package:shared_preferences/shared_preferences.dart';

class LocalUserData {
  static String localUserLoggedInKey = 'IsLoggedIn';
  static String localUserNameKey = 'UserNameKey';
  static String localUserEmailKey = 'UserEmailKey';
  static String localUserTypeKey = 'UserTypeKey';
  static String localChatList = 'UserChatList';
  static String localLastImageNameKey = 'LastImageName';
  static String localImageName = 'localImageName';
  static String localPhotoURLKey = 'LocalPhotoURLKey';
  static String localUserAgeKey = 'LocalUserAgeKey';

  // Storing User Data in local storage

  static Future<void> saveLoggedInUserType(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localUserTypeKey, userType);
  }

  static Future<void> saveLoggedInKey(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(localUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameKey(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localUserNameKey, userName);
  }

  static Future<void> saveUserEmailKey(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localUserEmailKey, email);
  }

  static Future<void> saveChatList(List<String> chatList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(localChatList, chatList);
  }

  static Future<void> savePhotoURL(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localPhotoURLKey, url);
  }

  static Future<void> saveAge(int userAge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localUserAgeKey, userAge.toString());
  }

  static Future<void> saveImageName(String imageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localImageName, imageName);
  }

  static Future<void> saveLastImage(String imageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localLastImageNameKey, imageName);
  }

  // Getting user data from local storage

  static Future<String> getUserTypeKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      localUserTypeKey,
    );
  }

  static Future<bool> getUserIdKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
      localUserLoggedInKey,
    );
  }

  static getUserNameKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      localUserNameKey,
    );
  }

  static getUserEmailKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      localUserEmailKey,
    );
  }

  static getChatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(
      localChatList,
    );
  }

  static getPhotoURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      localPhotoURLKey,
    );
  }

  static getAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      localUserAgeKey,
    );
  }

  static getImageName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      localImageName,
    );
  }

  static getLastImageName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(localLastImageNameKey);
  }
}

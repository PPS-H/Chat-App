import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String UserLoginKey="IsLoggedIn";
  static String UserEmailKey="User-Email";
  static String UserNameKey="User-Name";

  //Functions

  //Setters
  static Future<bool> setUserLoginInfo(String info)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(UserLoginKey, info);
  }

  static Future<bool> setUserNameInfo(String info)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(UserNameKey, info);
  }

  static Future<bool> setUserEmailInfo(String info)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(UserEmailKey, info);
  }


  //Getters
  static Future<String> getUserLoginInfo()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(UserLoginKey);
  }

  static Future<String> getUserNameInfo()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(UserNameKey);
  }

  static Future<String> getUserEmailInfo()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(UserEmailKey);
  }
}
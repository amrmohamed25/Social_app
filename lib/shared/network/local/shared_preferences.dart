import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static SharedPreferences? sharedPreferences;

  static init() async{
    sharedPreferences= await SharedPreferences.getInstance();
  }

  // bool? isDark;
  static Future<bool> setBoolean({required String key,required bool value}) async{
    return await sharedPreferences!.setBool(key, value);
  }

  static Future<bool?> setData({required String key,required dynamic value}) async{
    if(value is bool)
      return await sharedPreferences!.setBool(key, value);
    if(value is String)
      return await sharedPreferences!.setString(key, value);
    if(value is int)
      return await sharedPreferences!.setInt(key, value);
    if(value is double)
      return await sharedPreferences!.setDouble(key, value);
    return null;
  }

  static dynamic getData(key) {
    return sharedPreferences!.get(key);
  }

  static Future<bool?> removeData(key) {
    return sharedPreferences!.remove(key);
  }

}
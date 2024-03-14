import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<bool?> getsignin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("Sign-in");
  }

  static Future setsignin(bool signin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("set Sign-In => : ${signin}");
    await pref.setBool("Sign-in", signin);
  }

  static Future<int?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("UserId");
  }

  static Future setUserId(int userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("set UserId => : ${userId}");
    await pref.setInt("UserId", userId);
  }

  static Future<int?> getUserRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("UserRole");
  }

  static Future setUserRole(int userRole) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("set UserRole => : ${userRole}");
    await pref.setInt("UserRole", userRole);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("user-email");
  }

  static Future setUserEmail(String userEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("user-email", userEmail);
  }

  static Future<String?> getLatLng() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userLatLng");
  }

  static Future setLatLng(double Lat, double Lng) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userLatLng", '$Lat,$Lng');
  }
}

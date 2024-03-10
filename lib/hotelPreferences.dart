import 'package:shared_preferences/shared_preferences.dart';

class HotelPreferences {
  static Future<int?> getHotelId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("HotelId");
  }

  static Future setHotelId(int hotelId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("set hotelId => : ${hotelId}");
    await pref.setInt("hotelId", hotelId);
  }

  static Future<String?> getHotelName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("hotelName");
  }

  static Future setHotelName(String hotelName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("hotelName", hotelName);
  }

  static Future<String?> getHotelImg() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("hotelImg");
  }

  static Future setHotelImg(String hotelImg) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("hotelImg", hotelImg);
  }
}

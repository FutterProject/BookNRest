import 'package:book_and_rest/pages/home.dart';
import 'package:book_and_rest/pages/myBooking.dart';
import 'package:book_and_rest/pages/myMap.dart';
import 'package:book_and_rest/pages/myfavorite.dart';
import 'package:book_and_rest/pages/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class IndexState extends StatefulWidget {
  const IndexState({super.key});

  @override
  State<IndexState> createState() => _IndexState();
}

class _IndexState extends State<IndexState> {
  int screenIndex = 0;
<<<<<<< HEAD
  final menuScreen = [Home(), MyBooking(), MyFavorite(), ProfilePage()];
  // final menuScreen = [Home(), MyBooking(), MyFavorite(), MyProfile()];
=======
  final menuScreen = [Home(), MyBooking(), MyFavorite(), MyProfile()];
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
  // final menuScreen = [Home(), ShowMap(), MyFavorite(), MyProfile()];

  void onTabTapped(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menuScreen[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // unselectedLabelStyle: TextStyle(color: Colors.grey),
        // showUnselectedLabels: true,
        // showSelectedLabels: true,
        selectedItemColor: const Color(0xFF7a2ed6),
        selectedIconTheme: const IconThemeData(color: Color(0xFF7a2ed6)),
        // unselectedItemColor: Colors.grey,
        // unselectedIconTheme: IconThemeData(color: Colors.grey),
        currentIndex: screenIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Symbols.search,
                weight: 700,
              ),
              label: 'search'),
          BottomNavigationBarItem(
              icon: Icon(
                Symbols.trip,
                weight: 700,
              ),
              label: 'bookings'),
          BottomNavigationBarItem(
              icon: Icon(
                Symbols.bookmarks,
                weight: 700,
              ),
              label: 'favorite'),
          BottomNavigationBarItem(
              icon: Icon(
                Symbols.account_circle,
                weight: 400,
                fill: 1,
                opticalSize: 20,
                size: 35,
              ),
              label: 'profile'),
        ],
      ),
    );
  }
}

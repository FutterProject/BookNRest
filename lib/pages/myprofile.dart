import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/loginPage.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_and_rest/pages/edit_profile_page.dart';
import 'package:book_and_rest/pages/widget/button_widget.dart';
import 'package:book_and_rest/pages/widget/profile_widget.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  appDatabase db = appDatabase();
  int? userId;

  void initState() {
    super.initState();
    // _futureBookingDetails = db.getBookingDetail(userId);
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserPreferences.getUserId();
    setState(() {});
  }

  Future logout() async {
    await UserPreferences.setsignin(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder<UsersModel?>(
        future: userId != null ? db.getUser(userId!) : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final user = snapshot.data;
            if (user != null) {
              return Builder(
                builder: (context) => Scaffold(
                  body: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      ProfileWidget(
                        imagePath:
                            "https://w7.pngwing.com/pngs/129/292/png-transparent-female-avatar-girl-face-woman-user-flat-classy-users-icon.png",
                        onClicked: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage(),
                                settings: RouteSettings(arguments: user)),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      buildName(user),
                      const SizedBox(height: 24),
                      buildAbout(user),
                      const SizedBox(height: 48),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.deepPurple),
                                  ),
                                ),
                              ),
                              onPressed: logout,
                              child: Text("Logout"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text('No user found with id: $userId');
            }
          }
        },
      )),
    );
  }

  Widget buildName(UsersModel user) => Column(
        children: [
          Text(
            user.usrName!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.usrEmail,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          )
        ],
      );

  Widget buildAbout(UsersModel user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.address!,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

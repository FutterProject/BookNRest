import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:book_and_rest/pages/model/user.dart';
import 'package:book_and_rest/pages/utils/user_preferences.dart';
import 'package:book_and_rest/pages/widget/button_widget.dart';
import 'package:book_and_rest/pages/widget/profile_widget.dart';
import 'package:book_and_rest/pages/widget/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  appDatabase db = appDatabase();
  int? userId;

  void initState() {
    super.initState();
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as UsersModel;
    final userNameController = TextEditingController(text: data.usrName);
    final userEmailController = TextEditingController(text: data.usrEmail);
    final userAddressController = TextEditingController(text: data.address);
    return FutureBuilder<UsersModel?>(
      future: userId != null ? db.getUser(userId!) : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var user = snapshot.data;
          if (user != null) {
            return Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(),
                body: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  physics: BouncingScrollPhysics(),
                  children: [
                    ProfileWidget(
                      imagePath:
                          "https://w7.pngwing.com/pngs/129/292/png-transparent-female-avatar-girl-face-woman-user-flat-classy-users-icon.png",
                      // isEdit: true,
                      onClicked: () async {},
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'Add your Name',
                        labelText: "ชื่อ-นามสกุล",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Empty';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Add your Email',
                        labelText: "E-mail",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Empty';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: userAddressController,
                      decoration: InputDecoration(
                        hintText: 'Add yout Address',
                        labelText: "Address",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Empty';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
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
                            onPressed: () {
                              Map input = {
                                'userId': userId,
                                'userName': userNameController.text,
                                'userEmail': userEmailController.text,
                                'userPass': user.usrPassword,
                                'address': userAddressController.text,
                              };
                              update(input);
                              Navigator.pop(context);
                            },
                            child: Text('Save Changes'),
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
    );
  }

  void update(Map input) async {
    UsersModel data = UsersModel(
      usrId: input['userId'],
      usrName: input['userName'],
      usrEmail: input['userEmail'],
      usrPassword: input['userPass'],
      address: input['address'],
    );
    await db.updateUser(data);
  }
}

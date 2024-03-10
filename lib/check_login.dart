import 'package:book_and_rest/pages/index.dart';
import 'package:book_and_rest/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:book_and_rest/userPreferences.dart';

class check_login extends StatefulWidget {
  const check_login({Key? key}) : super(key: key);

  @override
  State<check_login> createState() => _check_loginState();
}

class _check_loginState extends State<check_login> {
  Future checklogin() async {
    bool? signin = await UserPreferences.getsignin();
    print("==Check Boolean : $signin");
    if (signin == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IndexState()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    }
  }

  void initState() {
    checklogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

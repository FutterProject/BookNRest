// import 'package:firebase_core/firebase_core.dart';
import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/hotel/indexHotel.dart';
import 'package:book_and_rest/pages/hotel/regisCusPage.dart';
import 'package:book_and_rest/pages/hotel/regisHotelPage.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_and_rest/pages/index.dart';
// import './hotel/hotelPage.dart';
// import 'regisCusPage.dart';
// import 'package:book_and_rest/hotel/indexHotel.dart';
// import 'package:book_and_rest/hotel/testPage.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final db = appDatabase();
  final _formKey = GlobalKey<FormState>();
  // final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;
  login(BuildContext context) async {
    var response = await db.queryUser(UsersModel(
        usrEmail: userEmailController.text,
        // usrName: userNameController.text,
        usrPassword: passwordController.text));
    if (response.isNotEmpty == true) {
      response.forEach((data) async {
        // ทำสิ่งที่คุณต้องการกับข้อมูลแต่ละรายการที่ได้
        await UserPreferences.setsignin(true);
        await UserPreferences.setUserId(data.usrId!);
        await UserPreferences.setUserRole(data.role!);

        if (data.role == 1) {
          print('${data.usrId}');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => IndexState()));
          if (!mounted) return;
        } else {
          print("Admin : ${data.usrName}");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => hotelState(
                        user_id: data.usrId,
                      )));
        }
      });
    } else {
      //If not, true the bool value to show error message
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Email or Password is incorrect."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(children: [
              Container(
                padding: EdgeInsets.only(top: 400),
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icons/Book&Rest-logo2.png'),
                        fit: BoxFit.contain)),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userEmailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'E-mail',
                            icon: Icon(
                              Icons.email,
                              color: Color.fromRGBO(135, 97, 244, 1),
                            )),
                        // validator: (value) {
                        //   if (value!.length == 0) {
                        //     return "Email cannot be empty";
                        //   }
                        //   if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        //       .hasMatch(value)) {
                        //     return ("Please enter a valid email");
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        onSaved: (value) {
                          userEmailController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autofocus: true,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            icon: Icon(
                              Icons.lock,
                              color: Color.fromRGBO(135, 97, 244, 1),
                            )),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (!regex.hasMatch(value)) {
                            return ("please enter valid password min. 6 character");
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     GestureDetector(
                      //         onTap: () {},
                      //         child: Text(
                      //           'Forgot Password?',
                      //           style: TextStyle(color: Colors.blue[900]),
                      //         )),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(context);
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(135, 97, 244, 1),
                          minimumSize:
                              Size(400, 50), // กำหนดความกว้างและความสูงของปุ่ม
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      height: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                      children: [Text('or', style: TextStyle(fontSize: 10))]),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      height: 0.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => regisCusPage()));
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(222, 209, 255, 1),
                  minimumSize: Size(400, 50), // กำหนดความกว้างและความสูงของปุ่ม
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

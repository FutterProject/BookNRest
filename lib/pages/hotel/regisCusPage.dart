import 'dart:math';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_and_rest/pages/home.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/abs/icon_generator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'regisHotelPage.dart';
// import 'loginPage.dart';

class regisCusPage extends StatefulWidget {
  const regisCusPage({super.key});

  @override
  State<regisCusPage> createState() => _regisCusPageState();
}

class _regisCusPageState extends State<regisCusPage> {
  // CollectionReference userCollection =
  // FirebaseFirestore.instance.collection('Users');
  // final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure2 = true;

  void signUserUp(String email, String password, String rule) async {
    CircularProgressIndicator();
    // if (_formKey.currentState!.validate()) {
    //   await _auth
    //       .createUserWithEmailAndPassword(email: email, password: password)
    //       .then((value) => {postDetailsToFirestore(email, password, rule)})
    //       .catchError((e) {});
    // }
  }

  // postDetailsToFirestore(String email, String password, String rule) async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   var user = _auth.currentUser;
  //   CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  //   CollectionReference cus = FirebaseFirestore.instance.collection('Customer');
  //   ref.doc(user!.uid).set({
  //     'email': emailController.text,
  //     'password': passwordController.text,
  //     'rule': rule
  //   });
  //   cus.doc(user!.uid).set({
  //     'userName': userNameController.text,
  //     'firstName': firstNameController.text,
  //     'lastName': lastNameController.text,
  //   });
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => login()));
  // }
  // postDetailsToFirestore(String email, String password, String rule) async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   var user = _auth.currentUser;
  //   CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  //   CollectionReference cus = FirebaseFirestore.instance.collection('Customer');
  //   ref.doc(user!.uid).set({
  //     'email': emailController.text,
  //     'password': passwordController.text,
  //     'rule': rule
  //   });
  //   cus.doc(user!.uid).set({});
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => login()));
  // }
  // void signUserup(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   try {
  //     if (passwordController.text == confirmPasswordController.text) {
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text,
  //         password: passwordController.text,
  //       );
  //       Navigator.pop(context);
  //     } else {
  //       print("Passwords don't match");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //   }
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(135, 97, 244, 1)),
        // title: Center(
        //   child: Text('Register',
        //       style: GoogleFonts.poppins(
        //           textStyle: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w600,
        //               fontSize: 22))),
        // ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.only(top: 400),
                height: 100,
                width: 300,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/Frame.png'),
                        fit: BoxFit.contain)),
              ),
              // SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Create account as ',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      children: [
                        TextSpan(
                          text: 'Customer',
                          style: TextStyle(
                            color: Color.fromRGBO(214, 200, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '         sign up for a new account to unlock exclusive benefits and start booking your '
                    'dream hotel stays. Fill in the required information below to create your customer account'
                    'and begin your journey with us.',
                    // textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              // Center(
              //     child: Text(
              //   'Create accout',
              //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              // )),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter your firstname';
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter your lastname';
                            },
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 15),
                    // TextFormField(
                    //   controller: userNameController,
                    //   autofocus: true,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'Username',
                    //     // icon: Icon(Icons.email)
                    //   ),
                    //   validator: (value) {
                    //     if (value!.isEmpty) return 'Please enter your username';
                    //   },
                    // ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: emailController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        // icon: Icon(Icons.email)
                      ),
                      validator: (value) {
                        if (value!.length == 0) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please enter a valid email");
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        // icon: Icon(Icons.lock)
                      ),
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
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure2 = !_isObscure2;
                              });
                            },
                            icon: Icon(_isObscure2
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        // icon: Icon(Icons.key)
                      ),
                      validator: (value) {
                        if (confirmPasswordController.text !=
                            passwordController.text) {
                          return "Password did not match";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        // icon: Icon(Icons.key)
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Fill your phone number';
                        if (value.length > 12) {
                          return 'Too long';
                        }

                        if (!RegExp(r'^[0-9]+$').hasMatch(value))
                          return 'Number only';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                          //   signUserup(context);
                          //   userCollection.add({
                          //     'firtName': firstNameController.text,
                          //     'lastName': lastNameController.text,
                          //     'username': userNameController.text,
                          //     'e-mail': emailController.text,
                          //     'phoneNumber': phoneNumberController.text,
                          //     'password': passwordController.text,
                          //     'rule': 'customer'
                          //   });
                          // }
                          signUserUp(emailController.text,
                              passwordController.text, 'customer');
                        },
                        child: TextButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                confirmPasswordController.text.isEmpty) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Register Failed"),
                                    content:
                                        Text("Please fill Email and Password."),
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
                            Navigator.pop(context);
                            //ส่งค่าไป insert
                            UsersModel userModel = UsersModel(
                                usrName:
                                    '${firstNameController.text} + ${lastNameController.text}',
                                usrEmail: emailController.text,
                                usrPassword: passwordController.text,
                                address: phoneNumberController.text,
                                role: 1);
                            await db.InsertRegister(userModel);
                          },
                          child: Text(
                            'Confirm Register',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(135, 97, 244, 1),
                            minimumSize: Size(400, 50),
                          ),
                        )),
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
                        Column(children: [
                          Text('or', style: TextStyle(fontSize: 10))
                        ]),
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => regisHotelPage()));
                      },
                      child: Text(
                        //ส่งไปหน้าhotel
                        'Register as Hotel',
                        style: GoogleFonts.poppins(
                            color: Color.fromRGBO(135, 97, 244, 1),
                            fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                        side:
                            BorderSide(color: Color.fromRGBO(135, 97, 244, 1)),
                        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                        elevation: 1,
                        minimumSize:
                            Size(400, 50), // กำหนดความกว้างและความสูงของปุ่ม
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   child: Icon(Icons.arrow_back),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

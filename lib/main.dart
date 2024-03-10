<<<<<<< HEAD
import 'package:book_and_rest/check_login.dart';
import 'package:book_and_rest/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
=======
import 'package:book_and_rest/pages/index.dart';
import 'package:flutter/material.dart';
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book&Rest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
<<<<<<< HEAD
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: const check_login(),
=======
      ),
      debugShowCheckedModeBanner: false,
      home: const IndexState(),
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
    );
  }
}

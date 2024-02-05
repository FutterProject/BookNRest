import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/destination.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:custom_calender_picker2/custom_calender_picker2.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  appDatabase db = appDatabase();
  DateTimeRange? rangeDateTime;
  final DateTime now = DateTime.now();
  late DateTime rangeDateTimeStart; // วันที่ปัจจุบัน
  late DateTime rangeDateTimeEnd; // วันถัดไป

  bool submit = false;
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  var checkInController = TextEditingController();
  var checkOutController = TextEditingController();
  String? _selectedProvince;
  //เอาไว้เซ็ต ค่าวันที่ ก่อนที่แอปจะทำงาน
  @override
  void initState() {
    super.initState();
    // set defautl = this day
    rangeDateTimeStart = now; // วันที่ปัจจุบัน
    rangeDateTimeEnd = now.add(const Duration(days: 1)); // วันถัดไป
    rangeDateTime =
        DateTimeRange(start: rangeDateTimeStart, end: rangeDateTimeEnd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      body: SafeArea(
        child: Column(
          // direction: Axis.vertical,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: Wrap(
                children: [
                  FutureBuilder<List<HotelModel>>(
                    future: db.getAllData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("NoData");
                      } else {
                        return SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              HotelModel hotel = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        '${hotel.img}',
                                        height: double.infinity,
                                        width: 220,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${hotel.name}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Symbols.location_on,
                                                color: Colors.white,
                                                weight: 700,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${hotel.city}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(child: Text("Test")),
          ],
        ),
      ),
    );
  }
}

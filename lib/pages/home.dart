import 'dart:math';

import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/destination.dart';
import 'package:book_and_rest/pages/hoteldetail.dart';
import 'package:book_and_rest/pages/index.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/pages/searchHotel.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:custom_calender_picker2/custom_calender_picker2.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:geolocator/geolocator.dart';
appDatabase db = appDatabase();

class Home extends StatefulWidget {
  const Home({super.key});
  // final UserModel userModel;
  // Home({Key? key, required this.userModel}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  // UserModel? userModel;
  DateTimeRange? rangeDateTime;
  final DateTime now = DateTime.now();
  late DateTime rangeDateTimeStart; // วันที่ปัจจุบัน
  late DateTime rangeDateTimeEnd; // วันถัดไป

  bool submit = false;
  final formKey = GlobalKey<FormState>();
  String? _selectedProvince;
  String? selectedProvince;

  double? myLat, myLong;
  double? hotelLat, hotelLong, distance;
  String? distanceString;
  //เอาไว้เซ็ต ค่าวันที่ ก่อนที่แอปจะทำงาน
  @override
  void initState() {
    super.initState();
    // set defautl = this day
    rangeDateTimeStart = now; // วันที่ปัจจุบัน
    rangeDateTimeEnd = now.add(const Duration(days: 1)); // วันถัดไป
    rangeDateTime =
        DateTimeRange(start: rangeDateTimeStart, end: rangeDateTimeEnd);
    findLocation();
    initCheckinCheckOut();
  }

  void initCheckinCheckOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'checkindate', rangeDateTime!.start.toString().substring(0, 10));
    await prefs.setString(
        'checkoutdate', rangeDateTime!.end.toString().substring(0, 10));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/icons/Book&Rest-logo2.png',
                      width: 200,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Where would you like to go?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      selectedProvince = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const destination()),
                      );
                      print("Test: $selectedProvince");
                      if (selectedProvince != null) {
                        setState(() {
                          _selectedProvince = selectedProvince;
                          print("Selected Province: $_selectedProvince");
                        });
                      }
                    },
                    child: TextFormField(
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: _selectedProvince ?? "City, landmark, hotel",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      enabled: false,
                      validator: (value) {
                        if (_selectedProvince == null ||
                            _selectedProvince!.isEmpty) return "empty";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            var result = await showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => CustomCalenderPicker(
                                returnDateType: ReturnDateType.range,
                                initialDateRange: rangeDateTime,
                                calenderThema: CalenderThema.dark,
                                rangeColor: Colors.grey.withOpacity(.3),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(28),
                                  bottom: Radius.zero,
                                ),
                                minDate: DateTime(now.year, now.month,
                                    now.day), // กำหนด minDate ที่นี่
                                maxDate: DateTime(now.year + 1, now.month,
                                    now.day), // และ maxDate ที่นี่
                              ),
                            );
                            if (result != null) {
                              if (result is DateTimeRange) {
                                rangeDateTime = result;
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'checkindate',
                                    rangeDateTime!.start
                                        .toString()
                                        .substring(0, 10));
                                await prefs.setString(
                                    'checkoutdate',
                                    rangeDateTime!.end
                                        .toString()
                                        .substring(0, 10));
                                setState(() {});
                              }
                            }
                          },
                          child: TextFormField(
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: rangeDateTime == null
                                  ? "Choose range date"
                                  : '${DateFormat('MMM dd').format(rangeDateTime!.start)} - ${DateFormat('MMM dd').format(rangeDateTime!.end)}',
                              prefixIcon:
                                  const Icon(Icons.calendar_month_outlined),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            enabled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // final SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // await prefs.setString('checkindate',
                          //     rangeDateTime!.start.toString().substring(0, 10));
                          // await prefs.setString('checkoutdate',
                          //     rangeDateTime!.end.toString().substring(0, 10));

                          if (formKey.currentState!.validate() &&
                              rangeDateTime != null &&
                              _selectedProvince != null) {
                            submit = !submit;
                            setState(() {
                              print("=========Click on Search=========");
                              // db.showAllRoom();
                            });

                            var sendData = [
                              _selectedProvince.toString().toLowerCase(),
                              rangeDateTime!.start.toString().substring(0, 10),
                              rangeDateTime!.end.toString().substring(0, 10),
                              myLat,
                              myLong,
                            ];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchHotel(),
                                settings: RouteSettings(arguments: sendData),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7a2ed6),
                          // fixedSize: Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Search",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   rangeDateTime == null
                  //       ? ''
                  //       : '${rangeDateTime!.start.toString().substring(0, 10)} - ${rangeDateTime!.end.toString().substring(0, 10)}',
                  // ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Popular Hotels",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: Wrap(
                      children: [
                        _buildPopularHotels(),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Near Me",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildNearest()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setUsetLocation() async {
    await UserPreferences.setLatLng(myLat!, myLong!);
  }

  Future findLocation() async {
    LocationData? locationData = await findLocationData();
    if (locationData != null) {
      if (mounted) {
        setState(() {
          myLat = locationData.latitude!;
          myLong = locationData.longitude!;
          setUsetLocation();
          // distance = calculateDistance(myLat!, myLong!, hotelLat!, hotelLong!);
          // var myFormat = NumberFormat('#0.0#', 'en_US');
          // distanceString = myFormat.format(distance);
          // print('Distance from me to hotel : $distance => $distanceString');
        });
      }
    } else {
      if (mounted) {
        setState(
          () {
            //set default at Victory Monument
            myLat = 13.764943059692726;
            myLong = 100.53828945433192;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Location Access Denied'),
                  content: Text(
                      'Please enable location access to use this feature.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    }
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      //เดี๋ยวจะแก้เป็นเช็คจากโลเคชั่นจริงๆ ใน near hotel
      selectedProvince = 'bangkok';
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission Denied');
        selectedProvince = 'bangkok';
      }
      return null;
    }
  }

  Widget _buildPopularHotels() {
    return FutureBuilder<List<HotelAllModel>>(
      future: db.getAvailableHotelsWithFilter(
        rangeDateTime!.start.toString().substring(0, 10),
        rangeDateTime!.end.toString().substring(0, 10),
        // selectedProvince.toString().toLowerCase(),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<HotelAllModel> hotels = snapshot.data!;
          hotels.sort((a, b) => b.ratings.compareTo(a.ratings));
          return SizedBox(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length < 5 ? snapshot.data!.length : 5,
              itemBuilder: (context, index) {
                HotelAllModel hotel = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          // final SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // await prefs.setString('checkindate',
                          //     rangeDateTime!.start.toString().substring(0, 10));
                          // await prefs.setString('checkoutdate',
                          //     rangeDateTime!.end.toString().substring(0, 10));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotelDetail(
                                      hotelId: hotel.hotelId,
                                    )),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            '${hotel.img}',
                            height: double.infinity,
                            width: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: Color.fromARGB(255, 0, 0, 0),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text("NoData");
        }
      },
    );
  }

  Widget _buildNearest() {
    print("buildNearest working....");
    return FutureBuilder<List<HotelAllModel>>(
      future: db.getAvailableHotelsWithFilter(
        rangeDateTime!.start.toString().substring(0, 10),
        rangeDateTime!.end.toString().substring(0, 10),
        selectedProvince.toString().toLowerCase(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          print('Stack trace: ${snapshot.stackTrace}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<HotelAllModel> hotels = snapshot.data!;
          // เรียงลำดับตามที่ผู้ใช้เลือก
          for (var hotel in hotels) {
            if (myLat != null && myLong != null) {
              hotelLat = double.parse(hotel.lat);
              hotelLong = double.parse(hotel.long);
              var displacement =
                  calculateDistance(myLat!, myLong!, hotelLat!, hotelLong!);
              var myFormat = NumberFormat('#0.0#', 'en_US');
              distanceString = myFormat.format(displacement);
              print('== hotel "${hotel.name}" displacement "$displacement"');
              print(
                  '== hotel "${hotel.name}" distanceString "$distanceString"');
              hotel.displacement = double.parse(distanceString!);
              print(
                  'myLat : ${myLat!} | myLong : ${myLong!} ==== hotelLat : $hotelLat | hotelLong : $hotelLong');
            }
          }
          hotels.sort((a, b) => a.displacement!.compareTo(b.displacement!));
          return SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: snapshot.data!.length < 3 ? snapshot.data!.length : 3,
              itemBuilder: (context, index) {
                HotelAllModel hotel = snapshot.data![index];
                return Card(
                    child: GestureDetector(
                        onTap: () async {
                          // final SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // await prefs.setString('checkindate',
                          //     rangeDateTime!.start.toString().substring(0, 10));
                          // await prefs.setString('checkoutdate',
                          //     rangeDateTime!.end.toString().substring(0, 10));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotelDetail(
                                      hotelId: hotel.hotelId,
                                    )),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                '${hotel.img}',
                                width: 150,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                                child: Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotel.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Symbols.location_on,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          '${hotel.displacement!.toString()} km.',
                                          // hotel.city,
                                          maxLines: 1,
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Symbols.star,
                                          color: Colors.yellow,
                                          fill: 1,
                                        ),
                                        Text(hotel.ratings.toString())
                                        // Text("5")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${hotel.min_price}',
                                          // '\$80',
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          '/night',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))
                          ],
                        )));
              },
            ),
          );
        } else {
          return const Center(child: Text('No hotels available'));
        }
      },
    );
  }
}

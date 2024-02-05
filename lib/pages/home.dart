import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/destination.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/pages/searchHotel.dart';
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
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Where would you like to go?",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final selectedProvince = await Navigator.push(
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
                        if (formKey.currentState!.validate() &&
                            rangeDateTime != null &&
                            _selectedProvince != null) {
                          submit = !submit;
                          setState(() {
                            print("=========Click on Search=========");
                            // db.showAllRoom();
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchHotel()));
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                const SizedBox(height: 30),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Wrap(
                    children: [
                      FutureBuilder<List<HotelModel>>(
                        future: db.getAllData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  HotelModel hotel = snapshot.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            '${hotel.img}',
                                            height: double.infinity,
                                            width: 220,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.bottomLeft,
                                        //   child: Padding(
                                        //     padding: EdgeInsets.all(10),
                                        //     child: Text(
                                        //       '${hotel.name}',
                                        //       style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 20,
                                        //         fontWeight: FontWeight.bold,
                                        //         backgroundColor: Colors.black
                                        //             .withOpacity(0.6),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Positioned(
                                          bottom: 10,
                                          left: 12,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                          offset:
                                                              Offset(1.0, 1.0),
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
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text("NoData");
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Near Me",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // const SizedBox(height: 30),
                // Expanded(
                //   child: FutureBuilder<List<RoomModel>>(
                //     future: db.showAllRoom(),
                //     // future: submit == false
                //     //     ? null
                //     //     : db.getAvailableRooms(
                //     //         _selectedProvince.toString().toLowerCase(),
                //     //         rangeDateTime!.start.toString().substring(0, 10),
                //     //         rangeDateTime!.end.toString().substring(0, 10)),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Center(child: CircularProgressIndicator());
                //       } else if (snapshot.hasError) {
                //         return Center(child: Text('Error: ${snapshot.error}'));
                //       } else if (snapshot.hasData &&
                //           snapshot.data!.isNotEmpty) {
                //         return ListView.builder(
                //           itemCount: snapshot.data!.length,
                //           itemBuilder: (context, index) {
                //             RoomModel room = snapshot.data![index];
                //             return ListTile(
                //               title: Text(room.roomNumber),
                //               subtitle: Text('${room.type}, ${room.price}'),
                //             );
                //           },
                //         );
                //       } else {
                //         return const Center(child: Text('No rooms available'));
                //       }
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'dart:async';

// import 'package:book_and_rest/hotel/testPage.dart';
// import 'package:book_and_rest/pages/hotel/databaseAsHotels.dart';
import 'package:book_and_rest/check_login.dart';
import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/home.dart';
import 'package:book_and_rest/pages/hoteldetail.dart';
import 'package:book_and_rest/pages/hotel/modelAsHotels.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

appDatabase db = appDatabase();

class hotelState extends StatefulWidget {
  const hotelState({super.key, this.user_id});

  final int? user_id;

  @override
  State<hotelState> createState() => _hotelState();
}

class _hotelState extends State<hotelState> {
  int screenIndex = 0;

  late final menuScreen = [
    Home(user_id: widget.user_id),
    CompleteScreen(user_id: widget.user_id),
    // RoomScreen(user_id: widget.user_id),
    ProfileScreen(id: widget.user_id)
  ];

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
                Symbols.bookmarks,
                weight: 700,
              ),
              label: 'Booking'),
          BottomNavigationBarItem(
              icon: Icon(
                Symbols.fact_check,
                weight: 700,
              ),
              label: 'Complete'),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Symbols.meeting_room,
          //       weight: 700,
          //     ),
          //     label: 'Rooms'),
          BottomNavigationBarItem(
              icon: Icon(
                Symbols.account_circle,
                weight: 700,
              ),
              label: 'My Hotel'),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, this.user_id});
  @override
  State<Home> createState() => _HomeState();
  final int? user_id;
}

class _HomeState extends State<Home> {
  DateTimeRange? rangeDateTime;
  final DateTime now = DateTime.now();
  late DateTime rangeDateTimeStart; // วันที่ปัจจุบัน
  late DateTime rangeDateTimeEnd; // วันถัดไป

  bool submit = false;
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  var checkInController = TextEditingController();
  var checkOutController = TextEditingController();
  // late Future<List<BookingModel>> _futureBookingDetails;

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
    // _futureBookingDetails =
    // db.getBookingAsHotel(BookingModel(user_id: widget.user_id));
  }

  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<BookingModel>>(
                    //------ ดึงข้อมูลทั้งหมดจากฐานข้อมูล -------
                    future: db.getBookingAsHotel(
                        BookingModel(user_id: widget.user_id)),
                    builder: (context, snapshot) {
                      //-------- ตรวจสอบว่ามีข้อมูลใน db.getAlldata หรือไม่ -------
                      //-------- ถ้ามีข้อมูลให้ดึงข้อมูลมาแสดงใน ListView.builder
                      //-------- ถ้าไม่มีข้อมูลให้ไปที่คำสั่ง else
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (index >= 0 && index < snapshot.data!.length) {
                              // ตรวจสอบว่าดัชนีที่ไม่เกินขอบเขตของลิสต์
                              BookingModel topic = snapshot.data![index];
                              if (topic.first_name!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.last_name!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.typeName!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.room_number!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.statusName!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase())) {
                                print('${topic.booking_id}');
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: Colors.black, width: 1)),
                                  color: Colors.white,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDetail(topic);
                                    },
                                    child: _listBooking(topic),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                                // return Center(child: Text('No Booking Now.'));
                              }
                            } else {
                              return SizedBox.shrink();
                              // return Center(child: Text('No Booking Now.'));
                            }
                          },
                        );
                        //-------- ถ้าไม่มีข้อมูลในฐานข้อมูลให้แสดงคำว่า 'No data' --------
                      } else {
                        return Center(child: Text('No Booking Now.'));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBooking(BookingModel model) {
    if (model.status == 1 || model.status == 2) {
      return ListTile(
        tileColor: Colors.white,
        leading: _leading(model),
        title: Text(
          'Room ${model.room_number} ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Name : '),
                Text('${model.first_name} ${model.last_name}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Checkin date : '),
                Text('${model.checkin_date}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Checkout date : '),
                Text('${model.checkout_date}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('Checkin status : '),
                Text(
                  '${model.statusName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _leading(BookingModel model) {
    if (model.status == 1) {
      return CircleAvatar(
        backgroundColor: Color.fromRGBO(212, 212, 214, 1),
        child: Icon(Symbols.event_upcoming,
            color: Color.fromRGBO(255, 255, 255, 1)),
      );
    } else if (model.status == 2) {
      return CircleAvatar(
        backgroundColor: Color.fromRGBO(135, 97, 244, 1),
        child: Icon(Symbols.hotel, color: Color.fromRGBO(255, 255, 255, 1)),
      );
    } else {
      return Center(
        child: Text('No Booking Now.'),
      );
    }
  }

  updatedata(Map input) async {
    BookingModel data =
        BookingModel(booking_id: input['booking_id'], status: input['status']);
    await db.updataStatusBooking(data);
  }

  showbutton(BookingModel model) {
    if (model.status == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Map input = {'status': 2, 'booking_id': model.booking_id};
              updatedata(input);
              setState(() {
                db.getBookingAsHotel(BookingModel(user_id: widget.user_id));
              });
              Navigator.pop(context);
            },
            //----- ปุ่ม Delete -----
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 26, 119, 7),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  'CheckIn',
                  style: TextStyle(color: Colors.white),
                ))),
          ),
          TextButton(
            onPressed: () {
              Map input = {'status': 4, 'booking_id': model.booking_id};
              updatedata(input);
              setState(() {
                db.getBookingAsHotel(BookingModel(user_id: widget.user_id));
              });
              Navigator.pop(context);
            },
            //----- ปุ่ม Delete -----
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  'Refund',
                  style: TextStyle(color: Colors.white),
                ))),
          ),
        ],
      );
    } else if (model.status == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Map input = {'status': 3, 'booking_id': model.booking_id};
              updatedata(input);
              setState(() {
                db.getBookingAsHotel(BookingModel(user_id: widget.user_id));
              });
              Navigator.pop(context);
            },
            //----- ปุ่ม Delete -----
            child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 26, 119, 7),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  'CheckOut',
                  style: TextStyle(color: Colors.white),
                ))),
          ),
        ],
      );
    } else {
      return Text('data');
    }
  }

  showDetail(BookingModel model) async {
    return showDialog(
        // barrierColor: Colors.white,
        context: context,
        builder: (context) {
          return AlertDialog(
            // backgroundColor: Color.fromRGBO(249, 239, 219, 1),
            backgroundColor: Colors.white,

            title: Container(
                child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Name : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('${model.first_name} ${model.last_name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'E-mail : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('${model.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Text('Phone Number : ', style: TextStyle(fontSize: 16)),
                    Text('${model.phone_number}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Text('Checkin date : ', style: TextStyle(fontSize: 16)),
                    Text('${model.checkin_date}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Checkout date : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text('${model.checkout_date}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Checkin status : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${model.statusName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                )
              ],
            )),
            actions: [
              showbutton(model),
              //----- ข้อความคำว่า Cancle -----
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancle',
                    style: TextStyle(color: Colors.green),
                  ))
            ],
          );
        });
  }
}

class addRoom extends StatefulWidget {
  const addRoom({Key? key, this.user_id}) : super(key: key);
  @override
  State<addRoom> createState() => _addRoomState();
  final int? user_id;
}

class _addRoomState extends State<addRoom> {
  final formKey = GlobalKey<FormState>();
  late Future<List<RoomModelForHotel>> data;
  late Future<List<getHotelModel>> hotel;

  @override
  void initState() {
    super.initState();
    hotel = db.getDetailHotel(getHotelModel(id: widget.user_id!));
    data = hotel.then((hotelData) {
      return db.getRoom(RoomModelForHotel(hotelId: hotelData.first.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7a2ed6),
        title: Center(
          child: Text(
            'Enter your Rooms',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    FutureBuilder<List<RoomModelForHotel>>(
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final hotelList = snapshot.data!;

                          if (hotelList.isNotEmpty) {
                            final hotelData = hotelList.first;
                            final room_numberController =
                                TextEditingController();
                            final typeController = TextEditingController();
                            final priceController = TextEditingController();
                            final room_descriptionController =
                                TextEditingController();
                            final adultController = TextEditingController();
                            final childController = TextEditingController();

                            // ทำสิ่งที่ต้องการกับข้อมูลที่ได้ ตามความเหมาะสม

                            return Form(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                    controller: room_numberController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Room Number',
                                    )),
                                SizedBox(height: 16),
                                TextFormField(
                                    controller: adultController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Adult',
                                    )),
                                SizedBox(height: 16),
                                TextFormField(
                                    controller: childController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Child',
                                    )),
                                SizedBox(height: 16),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: typeController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Room type',
                                  ),
                                  //ตรวจสอบการกรอกข้อมูลใน textfield
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                    controller: priceController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Price per Room',
                                    )),
                                SizedBox(height: 16),
                                TextFormField(
                                  maxLines: 8,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: room_descriptionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Room Description',
                                  ),
                                  //ตรวจสอบการกรอกข้อมูลใน textfield
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Map input = {
                                      'hotel_id': hotelData.hotelId,
                                      'room_number': room_numberController.text,
                                      'type': typeController.text,
                                      'price':
                                          double.parse(priceController.text),
                                      'room_description':
                                          room_descriptionController.text,
                                      'adult': int.parse(adultController.text),
                                      'child': int.parse(childController.text),
                                    };
                                    if (formKey.currentState!.validate()) {
                                      // insertRooms(input);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Add Room'),
                                ),
                              ],
                            )); // ส่งค่ากลับเมื่อสิ้นสุดการทำงาน
                          } else {
                            return Text('No data');
                          }
                        }

                        throw Exception(
                            'Unhandled snapshot state'); // ส่งค่า exception ถ้าอยู่ในสถานะที่ไม่ถูกต้อง
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void insertRooms(Map input) async {
  //   RoomModelForHotelForHotel data = RoomModelForHotelForHotel(
  //       hotelId: input['hotel_id'],
  //       roomNumber: input['room_number'],
  //       type: input['type'],
  //       price: input['price'],
  //       adult: input['adult'],
  //       child: input['child'],
  //       roomDescription: input['room_description']);
  //   await db.addRooms(data);
  // }
}

class updateForm extends StatefulWidget {
  const updateForm({Key? key, this.user_id}) : super(key: key);
  @override
  State<updateForm> createState() => _updateFormState();
  final int? user_id;
}

class _updateFormState extends State<updateForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7a2ed6),
        title: Center(
          child: Text(
            'Edit Your Hotel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    FutureBuilder<List<getHotelModel>>(
                      future:
                          db.getDetailHotel(getHotelModel(id: widget.user_id!)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final hotelList = snapshot.data!;

                          if (hotelList.isNotEmpty) {
                            final hotelData = hotelList.first;
                            final nameController =
                                TextEditingController(text: hotelData.name);
                            final descriptionController = TextEditingController(
                                text: hotelData.hotelDescription);

                            // ทำสิ่งที่ต้องการกับข้อมูลที่ได้ ตามความเหมาะสม

                            return Form(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                    controller: nameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Hotel Name',
                                        icon: Icon(
                                          Icons.domain,
                                          color:
                                              Color.fromRGBO(135, 97, 244, 1),
                                        ))),
                                SizedBox(height: 10),
                                TextFormField(
                                  maxLines: 8,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Start a new conversation',
                                      icon: Icon(
                                        Icons.description,
                                        color: Color.fromRGBO(135, 97, 244, 1),
                                      )),
                                  //ตรวจสอบการกรอกข้อมูลใน textfield
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please add a conversation';
                                    if (value!.length < 6)
                                      return 'Too short, length more than 6';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Map input = {
                                      'hotel_id': hotelData.id,
                                      'name': nameController.text,
                                      'hotel_description':
                                          descriptionController.text
                                    };
                                    if (formKey.currentState!.validate()) {
                                      updateData(input);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Update'),
                                ),
                              ],
                            )); // ส่งค่ากลับเมื่อสิ้นสุดการทำงาน
                          } else {
                            return Text('No data');
                          }
                        }

                        throw Exception(
                            'Unhandled snapshot state'); // ส่งค่า exception ถ้าอยู่ในสถานะที่ไม่ถูกต้อง
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateData(Map input) async {
    getHotelModel data = getHotelModel(
        id: input['hotel_id'],
        name: input['name'],
        hotelDescription: input['hotel_description']);
    await db.updateDetailHotel(data);
  }
}

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key, this.user_id});
  final int? user_id;
  @override
  State<CompleteScreen> createState() => CompleteScreenState();
}

class CompleteScreenState extends State<CompleteScreen> {
  DateTimeRange? rangeDateTime;
  final DateTime now = DateTime.now();
  late DateTime rangeDateTimeStart; // วันที่ปัจจุบัน
  late DateTime rangeDateTimeEnd; // วันถัดไป

  bool submit = false;
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  var checkInController = TextEditingController();
  var checkOutController = TextEditingController();
  late Future<List<BookingModel>> _futureBookingDetails;

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
    _futureBookingDetails =
        db.getBookingAsHotel(BookingModel(user_id: widget.user_id));
  }

  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<BookingModel>>(
                    //------ ดึงข้อมูลทั้งหมดจากฐานข้อมูล ------
                    future: db.getBookingAsHotel(
                        BookingModel(user_id: widget.user_id)),
                    builder: (context, snapshot) {
                      //-------- ตรวจสอบว่ามีข้อมูลใน db.getAlldata หรือไม่ --------
                      //-------- ถ้ามีข้อมูลให้ดึงข้อมูลมาแสดงใน ListView.builder
                      //-------- ถ้าไม่มีข้อมูลให้ไปที่คำสั่ง else
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (index >= 0 && index < snapshot.data!.length) {
                              // ตรวจสอบว่าดัชนีที่ไม่เกินขอบเขตของลิสต์
                              BookingModel topic = snapshot.data![index];
                              if (topic.first_name!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.last_name!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.typeName!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.room_number!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  topic.statusName!
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase())) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.black)),
                                  color: Colors.white,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDetail(topic);
                                    },
                                    child: _listBooking(topic),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                                // return Center(child: Text('No data'));
                              }
                            } else {
                              // return SizedBox.shrink();
                              return Center(child: Text('No data'));
                            }
                          },
                        );
                        //-------- ถ้าไม่มีข้อมูลในฐานข้อมูลให้แสดงคำว่า 'No data' --------
                      } else {
                        // return SizedBox.shrink();
                        return Center(child: Text('No data'));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBooking(BookingModel model) {
    if (model.status == 3) {
      return ListTile(
        tileColor: Colors.white,
        leading: _leading(model),
        title: Text(
          'Room ${model.room_number}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Name : '),
                Text('${model.first_name} ${model.last_name}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Checkin date : '),
                Text('${model.checkin_date}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Checkout date : '),
                Text('${model.checkout_date}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('Checkin status : '),
                Text(
                  '${model.statusName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => updateForm(),
            //     settings: RouteSettings(arguments: model),
            //   ),
            // ).then((_) {
            //   setState(() {
            //     db.getAllData();
            //   });
            // });
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      );
    } else if (model.status == 4) {
      return ListTile(
        tileColor: Colors.white,
        leading: _leading(model),
        title: Text(
          'Room ${model.room_number}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Name : '),
                Text('${model.first_name} ${model.last_name}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('E-mail : '),
                Text('${model.email}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Phone Number : '),
                Text('${model.phone_number}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Checkin date : '),
                Text('${model.checkin_date}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text('Checkout date : '),
                Text('${model.checkout_date}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('Checkin status : '),
                Text(
                  '${model.statusName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => updateForm(),
            //     settings: RouteSettings(arguments: model),
            //   ),
            // ).then((_) {
            //   setState(() {
            //     db.getAllData();
            //   });
            // });
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _leading(BookingModel model) {
    if (model.status == 3) {
      return CircleAvatar(
        backgroundColor: Color.fromRGBO(42, 104, 17, 1),
        child: Icon(Symbols.event_available,
            color: Color.fromRGBO(255, 255, 255, 1)),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Color.fromARGB(255, 223, 10, 10),
        child: Icon(Symbols.event_busy,
            color: const Color.fromARGB(255, 255, 255, 255)),
      );
    }
  }

  //-------------- ฟังก์ชันแสดง popup เพื่อแสดงรายละเอียดข้อมูล --------------
  showDetail(BookingModel model) async {
    return showDialog(
        // barrierColor: Colors.white,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: TextStyle(fontSize: 16),
                      'Name : ${model.first_name} ${model.last_name}',
                    ),
                    Text(
                      'Checkin date : ${model.checkin_date}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Checkout date : ${model.checkout_date}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Checkin status : ${model.statusName}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      db.deletBooking(model);
                      setState(() {
                        db.getBookingAsHotel(
                            BookingModel(user_id: widget.user_id));
                      });
                      Navigator.pop(context);
                    },
                    //----- ปุ่ม Delete -----
                    child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ))),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancle',
                        style: TextStyle(color: Colors.green),
                      ))
                ],
              ),
            ],
          );
        });
  }
}

// class RoomScreen extends StatefulWidget {
//   const RoomScreen({super.key, this.user_id});
//   final int? user_id;
//   @override
//   State<RoomScreen> createState() => _RoomScreenState();
// }

// class _RoomScreenState extends State<RoomScreen> {
//   String searchText = '';
//   late Future<List<RoomModelForHotel>> data;
//   late Future<List<getHotelModel>> hotel;

//   @override
//   void initState() {
//     super.initState();
//     hotel = db.getDetailHotel(getHotelModel(id: widget.user_id!));
//     data = hotel.then((hotelData) {
//       return db.getRoom(RoomModelForHotel(hotelId: hotelData.first.id));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FittedBox(
//         child: FloatingActionButton.extended(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => addRoom(user_id: widget.user_id)),
//             ).then((_) => setState(() {
//                   hotel = db.getDetailHotel(getHotelModel(id: widget.user_id!));
//                   data = hotel.then((hotelData) {
//                     return db.getRoom(RoomModelForHotel(hotelId: hotelData.first.id));
//                   });
//                 }));
//           },
//           label: Text("Add Room"),
//           icon: Icon(Icons.add),
//           backgroundColor: Color.fromRGBO(189, 173, 233, 1), // สีของ FAB
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     searchText = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                 ),
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder<List<RoomModelForHotel>>(
//                 future: data,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         RoomModelForHotel topic = snapshot.data![index];
//                         if (topic.roomNumber!
//                                 .toLowerCase()
//                                 .contains(searchText.toLowerCase()) ||
//                             topic.type!
//                                 .toLowerCase()
//                                 .contains(searchText.toLowerCase()) ||
//                             topic.roomDescription!
//                                 .toLowerCase()
//                                 .contains(searchText.toLowerCase()) ||
//                             topic.type!
//                                 .toLowerCase()
//                                 .contains(searchText.toLowerCase())) {
//                           return Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                               side: BorderSide(color: Colors.black, width: 1),
//                             ),
//                             color: Colors.white,
//                             child: GestureDetector(
//                               onTap: () {
//                                 // showDetail(topic);
//                               },
//                               child: ListTile(
//                                 tileColor: Colors.white,
//                                 leading: _leading(topic),
//                                 title: Text(
//                                   'Room Number: ${topic.roomNumber} ',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text('adult : '),
//                                           Text('${topic.adult}',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold))
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text('Child : '),
//                                           Text('${topic.child}',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold))
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text('Price: '),
//                                           Text('${topic.price}',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold))
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text('Type: '),
//                                           Text('${topic.type}',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold)),
//                                         ],
//                                       ),
//                                     ]),
//                               ),
//                             ),
//                           );
//                         } else {
//                           return SizedBox.shrink();
//                         }
//                       },
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _leading(RoomModelForHotel model) {
//     if (model.type!.contains('Single')) {
//       return CircleAvatar(
//         backgroundColor: Color.fromRGBO(135, 97, 244, 1),
//         child: Icon(Symbols.hotel, color: Color.fromRGBO(255, 255, 255, 1)),
//       );
//     } else if (model.type!.contains('Deluxe')) {
//       return CircleAvatar(
//         backgroundColor: Color.fromRGBO(135, 97, 244, 1),
//         child: Icon(Symbols.bed, color: Color.fromRGBO(247, 247, 247, 1)),
//       );
//     } else {
//       return Center(
//         child: Text('No Booking Now.'),
//       );
//     }
//   }
// }

class ProfileScreen extends StatefulWidget {
  final int? id;
  const ProfileScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => updateForm(user_id: widget.id)),
            ).then((_) => setState(() {
                  db.getDetailHotel(getHotelModel(id: widget.id!));
                }));
          },
          child: Icon(Icons.edit),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<getHotelModel>>(
                    future: widget.id != null
                        ? db.getDetailHotel(getHotelModel(id: widget.id!))
                        : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        getHotelModel htdetail = snapshot.data!.first;
                        return Column(
                          children: [
                            Text(
                              "${htdetail.name}",
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: Color.fromRGBO(135, 97, 244, 1)),
                            ),
                            Text(
                              "${htdetail.city}",
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.person, size: 30),
                                subtitle: const Text("Address"),
                                title: Text(
                                    "${htdetail.address} ${htdetail.city}"),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.email, size: 30),
                                title: Text("${htdetail.city}"),
                                subtitle: Text("City"),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.account_circle, size: 30),
                                title: const Text("Description"),
                                subtitle: Text('${htdetail.hotelDescription}'),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                await UserPreferences.setsignin(false);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => check_login()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 10),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 228, 14, 14),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(400, 50),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: Text('No data'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

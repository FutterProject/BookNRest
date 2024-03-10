import 'package:book_and_rest/pages/database.dart';
<<<<<<< HEAD
import 'package:book_and_rest/pages/hoteldetail.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
=======
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/material.dart';
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBooking();
}

@override
class _MyBooking extends State<MyBooking> {
<<<<<<< HEAD
  // Future<List<BookingDetailModel>>? _futureBookingDetails;
  appDatabase db = appDatabase();
  int? userId;
=======
  late Future<List<BookingDetailModel>> _futureBookingDetails;
  appDatabase db = appDatabase();
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    // _futureBookingDetails = db.getBookingDetail(userId);
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserPreferences.getUserId();
    setState(() {});
=======
    _futureBookingDetails = db.getBookingDetail();
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
<<<<<<< HEAD
      body: _buildMyBookingDetails(),
    );
  }

  _buildMyBookingDetails() {
    print("buildNearest working....");
    if (userId != null)
      return FutureBuilder<List<BookingDetailModel>>(
        future: db.getBookingDetail(userId!),
        // future: _futureBookingDetails,
        // ใช้ของพีแล้วมันไม่โชว์เอ๋อไรไม่รู้
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            print('Stack trace: ${snapshot.stackTrace}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length < 3 ? snapshot.data!.length : 3,
              itemBuilder: (context, index) {
                BookingDetailModel hotel = snapshot.data![index];
                return Card(
                  child: GestureDetector(
                    onTap: () {
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
                            '${hotel.hotelImg}',
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
                                  '${hotel.hotelName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  'check-in : ${hotel.checkInDate}',
                                ),
                                Text('check-out : ${hotel.checkOutDate}'),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
=======
      body: FutureBuilder<List<BookingDetailModel>>(
        future: _futureBookingDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BookingDetailModel> bookingDetails = snapshot.data!;
            return ListView.builder(
              itemCount: bookingDetails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking ID: ${bookingDetails[index].bookingId}'),
                      Text('Hotel ID: ${bookingDetails[index].hotelId}'),
                      Text('Room ID: ${bookingDetails[index].roomId}'),
                      Text(
                          'Selected Room Count: ${bookingDetails[index].selectedRoomCount}'),
                      Text('First Name: ${bookingDetails[index].firstName}'),
                      Text('Last Name: ${bookingDetails[index].lastName}'),
                      Text('Email: ${bookingDetails[index].email}'),
                      Text('Phone: ${bookingDetails[index].phone}'),
                      Text('CheckInDate: ${bookingDetails[index].checkInDate}'),
                      Text(
                          'CheckOutDate: ${bookingDetails[index].checkOutDate}')
                    ],
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
                  ),
                );
              },
            );
          } else {
<<<<<<< HEAD
            return const Center(child: Text('Not booking yet'));
          }

          // แสดงตัวโหลดขณะรอข้อมูล
        },
      );
=======
            return Center(
              child: Text('No bookings found.'),
            );
          }
        },
      ),
    );
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
  }
}

import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/hoteldetail.dart';
import 'package:book_and_rest/pages/hoteldetailpage.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBooking();
}

@override
class _MyBooking extends State<MyBooking> {
  // Future<List<BookingDetailModel>>? _futureBookingDetails;
  appDatabase db = appDatabase();
  int? userId;

  @override
  void initState() {
    super.initState();
    // _futureBookingDetails = db.getBookingDetail(userId);
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: _buildMyBookingDetails(),
    );
  }

  _buildMyBookingDetails() {
    print("buildNearest working....");
    if (userId != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder<List<BookingDetailModel>>(
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  BookingDetailModel hotel = snapshot.data![index];
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HotelDetailPage(
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
                              height: 200,
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
                                    'Room Type : ${hotel.roomType}',
                                  ),
                                  Text(
                                    'Room Number : ${hotel.roomId}',
                                  ),
                                  Text(
                                    'Number of Room : ${hotel.selectedRoomCount}',
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
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Not booking yet'));
            }

            // แสดงตัวโหลดขณะรอข้อมูล
          },
        ),
      );
    }
  }
}

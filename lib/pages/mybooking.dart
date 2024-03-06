import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/material.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBooking();
}

@override
class _MyBooking extends State<MyBooking> {
  late Future<List<BookingDetailModel>> _futureBookingDetails;
  appDatabase db = appDatabase();

  @override
  void initState() {
    super.initState();
    _futureBookingDetails = db.getBookingDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
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
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No bookings found.'),
            );
          }
        },
      ),
    );
  }
}

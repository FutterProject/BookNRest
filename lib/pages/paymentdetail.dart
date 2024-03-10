import 'package:book_and_rest/hotelPreferences.dart';
import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/home.dart';
import 'package:book_and_rest/pages/hoteldetailpage.dart';
import 'package:book_and_rest/pages/index.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class PaymentDetail extends StatefulWidget {
  final int hotelId;
  final int roomId;
  final int selectedRoomCount;
  final RoomModel room;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  PaymentDetail({
    required this.hotelId,
    required this.roomId,
    required this.selectedRoomCount,
    required this.room,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  appDatabase db = appDatabase();
  late Future<HotelModel?> _futureHotel;
  late Future<List<RoomModel?>> _futureRooms;
  late List<bool> isVisibleList;
  int selectedRoomCount = 1;
  int selectedPaymentMethod = 0;
  late List<int> selectedRoomCounts;
  bool isVisible = false;
  int? userId;
  int? hotelId;
  String? hotelName;
  String? hotelImg;
  final upiDetails =
      UPIDetails(upiID: "UPI ID", payeeName: "Payee Name", amount: 1);

  // optional or not?
  // final _countryController = TextEditingController();

  void updateRoomCount(int index, int count) {
    setState(() {
      selectedRoomCounts[index] = count;
    });
  }

  void initState() {
    super.initState();
    selectedRoomCount = widget.selectedRoomCount;
    _futureHotel = db.getHotelDetailById(widget.hotelId);
    _futureRooms = db.getRoomDetailById(widget.hotelId);
    initializePref();
  }

  Future<void> initializePref() async {
    userId = await UserPreferences.getUserId();
    hotelId = await HotelPreferences.getHotelId();
    hotelName = await HotelPreferences.getHotelName();
    hotelImg = await HotelPreferences.getHotelImg();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<HotelModel?>(
            future: _futureHotel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                HotelModel hotel = snapshot.data!;
                return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${hotel.img}',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 150,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    '${hotel.name}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Row(children: [
                                    Icon(Icons.star, color: Colors.yellow),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child:
                                            Text('Rating : ${hotel.ratings}')),
                                  ]),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                    child: Row(children: [
                                      Icon(Icons.location_on_sharp),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text('${hotel.address}'))
                                    ])),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HotelDetailPage(
                                                      hotelId:
                                                          widget.hotelId)));
                                    },
                                    child: Text(
                                      'See more',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])));
              } else {
                return Center(child: Text('Error loading hotel data'));
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Divider(
              height: 20,
              thickness: 7,
              color: Color.fromARGB(179, 202, 194, 194),
            ),
          ),
          FutureBuilder<List<RoomModel?>>(
            future: _futureRooms,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                List<RoomModel?> rooms = snapshot.data!;
                RoomModel? selectedRoom;
                for (RoomModel? room in rooms) {
                  if (room!.roomId == widget.roomId) {
                    selectedRoom = room;
                    break;
                  }
                }
                if (selectedRoom == null) {
                  return Center(child: Text('Selected room not found'));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${widget.room.roomImg}',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 150,
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: SizedBox(
                                  width: 250,
                                  child: Text(
                                    '${widget.selectedRoomCount} x ${widget.room.type}',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  'room price : ${selectedRoom.price}',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Text(
                                  'Max ${selectedRoom.adult} adults' +
                                      ' | Max ${selectedRoom.child} child' +
                                      ' (0-11 years)',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Text(
                                  '1 king bed / 2 single beds',
                                  style: TextStyle(fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text(
                                  'with taxes & fees',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$ ${(widget.room.price * selectedRoomCount * 1.177).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 223, 67, 55),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                                child: Text(
                                  selectedRoomCount == 1
                                      ? 'Room price (${selectedRoomCount} room x 1 night)'
                                      : 'Original price (${selectedRoomCount} rooms x 1 night)',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                              '\$ ${selectedRoom.price * selectedRoomCount}'),
                        ),
                        SizedBox(width: 20)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child:
                          Text('Include in price: Tax 7%, Service charge 10%'),
                    ),
                  ],
                );
              } else {
                return Center(child: Text('Error loading room data'));
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Divider(
              height: 20,
              thickness: 7,
              color: Color.fromARGB(179, 202, 194, 194),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                child: Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'All payment data is encrypted and secure',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 42, 138, 45)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    RadioListTile<int>(
                      title: Text('Credit/Debit Card'),
                      subtitle: isVisible != true
                          ? Text(
                              'Not available',
                              style: TextStyle(color: Colors.red),
                            )
                          : null,
                      value: 1,
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          if (selectedPaymentMethod != value) {
                            isVisible = false;
                          }
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Digital Payment'),
                      value: 2,
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(
                          () {
                            selectedPaymentMethod = value!;
                            isVisible = true;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: 0,
          height: 40,
          child: FittedBox(
            child: FloatingActionButton.extended(
              onPressed: selectedPaymentMethod == 2
                  ? () async {
                      Navigator.of(context).popUntil((route) => route.isFirst);

                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final String? cid = prefs.getString('checkindate');
                      final String? cod = prefs.getString('checkoutdate');
                      BookingDetailModel bookingDetailModel =
                          BookingDetailModel(
                        hotelId: widget.hotelId,
                        roomId: widget.roomId,
                        selectedRoomCount: widget.selectedRoomCount,
                        firstName: widget.firstName,
                        lastName: widget.lastName,
                        email: widget.email,
                        phone: widget.phone,
                        checkInDate: cid,
                        checkOutDate: cod,
                        userId: userId,
                      );
                      await db.InsertBookingDetail(bookingDetailModel);
                    }
                  : null,
              label: Text(
                'BOOK NOW',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              backgroundColor: Color(0xFF7a2ed6),
            ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder myinputborder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 196, 179, 218),
      width: 3,
    ),
  );
}

OutlineInputBorder myfocusborder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Color(0xFF7a2ed6),
      width: 3,
    ),
  );
}

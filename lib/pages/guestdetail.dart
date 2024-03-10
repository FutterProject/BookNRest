import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/hoteldetailpage.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/pages/paymentdetail.dart';
import 'package:flutter/material.dart';

class GuestDetail extends StatefulWidget {
  final int hotelId;
  final int roomId;
  final int selectedRoomCount;
  final RoomModel room;

  GuestDetail(
      {required this.hotelId,
      required this.roomId,
      required this.selectedRoomCount,
      required this.room});

  @override
  State<GuestDetail> createState() => _GuestDetailState();
}

class _GuestDetailState extends State<GuestDetail> {
  final formKey = GlobalKey<FormState>();
  appDatabase db = appDatabase();
  late Future<HotelModel?> _futureHotel;
  late Future<List<RoomModel?>> _futureRooms;
  late List<bool> isVisibleList;
  int selectedRoomCount = 1;
  late List<int> selectedRoomCounts;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // optional or not?
  // final _countryController = TextEditingController();

  void updateRoomCount(int index, int count) {
    setState(
      () {
        selectedRoomCounts[index] = count;
      },
    );
  }

  void initState() {
    super.initState();
    selectedRoomCounts = [];
    selectedRoomCount = widget.selectedRoomCount;
    _futureHotel = db.getHotelDetailById(widget.hotelId);
    _futureRooms = db.getRoomDetailById(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Guest Details'),
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
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Text(
                                          'Rating : ${hotel.ratings}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_sharp),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Text('${hotel.address}'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotelDetailPage(
                                              hotelId: widget.hotelId),
                                        ),
                                      );
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
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('Error'),
                  );
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
                if (snapshot.hasData) {
                  List<RoomModel?> rooms = snapshot.data!;
                  RoomModel? selectedRoom;
                  for (RoomModel? room in rooms) {
                    if (room!.roomId == widget.roomId) {
                      selectedRoom = room;
                      break;
                    }
                  }
                  if (selectedRoom == null) {
                    return Center(
                      child: Text('not found'),
                    );
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
<<<<<<< HEAD
                                  child: SizedBox(
                                    width: 250,
                                    child: Text(
                                      '${widget.selectedRoomCount} x ${widget.room.type}',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
=======
                                  child: Text(
                                    '${widget.selectedRoomCount} x ${widget.room.type}',
                                    style: TextStyle(fontSize: 25),
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                            '\$ ${(selectedRoom.price * selectedRoomCount * 1.177).toStringAsFixed(2)}',
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
                        child: Text(
                            'Include in price: Tax 7%, Service charge 10%'),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text('Error'),
                  );
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: Icon(
                        Icons.perm_contact_calendar_rounded,
                        size: 50,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 0, 0),
                      child: Text(
                        'Contact details',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: "First name *",
                            border: OutlineInputBorder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Fill your first number';
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: "Last name *",
                            border: OutlineInputBorder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Fill your last name';
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email *",
                            border: OutlineInputBorder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Fill your email';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value))
                              return 'Please enter valid email';
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone number *",
                            border: OutlineInputBorder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: 0,
          height: 40,
          child: FittedBox(
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (_firstNameController.text.isEmpty ||
                      _lastNameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _phoneController.text.isEmpty) {
                  } else {
                    List<RoomModel?> rooms = await _futureRooms;
                    int roomId = rooms.isNotEmpty ? rooms[0]?.roomId ?? 0 : 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentDetail(
                          selectedRoomCount: selectedRoomCount,
                          hotelId: widget.hotelId,
                          roomId: roomId,
                          room: widget.room,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                        ),
                      ),
                    );
                  }
                }
              },
              label: Text(
                'Next step',
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

import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/guestdetail.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'model.dart';

class RoomDetail extends StatefulWidget {
  final int hotelId;

  RoomDetail({required this.hotelId});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  appDatabase db = appDatabase();
  late Future<List<RoomModel?>> _futureRooms;
  late List<bool> isVisibleList;
  int selectedRoomCount = 1;
  late List<int> selectedRoomCounts;

  void updateRoomCount(int index, int count) {
    setState(
      () {
        selectedRoomCounts[index] = count;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _futureRooms = db.getRoomDetailById(widget.hotelId);
    isVisibleList = [];

    _futureRooms.then(
      (rooms) {
        selectedRoomCounts = List.filled(rooms.length, 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Detail'),
      ),
      body: FutureBuilder<List<RoomModel?>>(
        future: _futureRooms,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RoomModel?> rooms = snapshot.data!;
            if (isVisibleList.isEmpty) {
              isVisibleList = List.generate(rooms.length, (_) => false);
            }
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                RoomModel room = rooms[index]!;
                if (selectedRoomCounts[index] > 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 15, 0, 10),
                        child: Text(
                          '${room.type}',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${room.roomImg}',
                              fit: BoxFit.cover,
                              width: 200,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    'room price : ${room.price}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: Text(
                                    'Max ${room.adult} adults',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: Text(
                                    'Max ${room.child} child',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 15, 0, 0),
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
                      Visibility(
                        visible: isVisibleList[index],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                              child: Text(
                                '${room.roomDescription}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                              // amenities ตอนนี่มีแค่สำหรับโรงแรม
                              // child: TextButton(
                              //   onPressed: () {
                              //     roomAmenitiesModalBottomSheet(
                              //         context, index);
                              //   },
                              //   child: Text('See all amenities',
                              //       style: TextStyle(
                              //           fontSize: 13, color: Colors.blue)),
                              // ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    roomCountModalBottomSheet(
                                      context,
                                      (int count) {
                                        updateRoomCount(index, count);
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 196, 179, 218),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Room : ${selectedRoomCounts[index]}',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GuestDetail(
                                          selectedRoomCount:
                                              selectedRoomCounts[index],
                                          hotelId: room.hotelId,
                                          roomId: room.roomId ?? 0,
                                          room: room,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Book',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 140, 76, 218),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: Color.fromARGB(255, 196, 179, 218),
                                width: 2),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                isVisibleList[index] = !isVisibleList[index];
                              },
                            );
                          },
                          child: Text(isVisibleList[index]
                              ? 'Show less details'
                              : 'Show all details'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Divider(
                          height: 20,
                          thickness: 7,
                          color: Color.fromARGB(179, 202, 194, 194),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else {
            return Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}

void roomCountModalBottomSheet(context, Function(int) onRoomCountSelected) {
  int selectedRoomCount = 1;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              width: 500,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'Select Number of Rooms:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        50,
                        (index) => InkWell(
                          onTap: () {
                            setState(
                              () {
                                selectedRoomCount = index + 1;
                                onRoomCountSelected(selectedRoomCount);
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selectedRoomCount == index + 1
                                  ? Colors.blue.withOpacity(0.5)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

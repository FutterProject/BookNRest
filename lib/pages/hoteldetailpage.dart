import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/pages/roomdetail.dart';
import 'package:flutter/material.dart';

import 'database.dart';

//ในส่วนของหน้านี่มีหน้าที่ให้ user ที่เลือกโรงแรมแล้วต้องการดูรายละเอียดของโรงแรมอย่างชัดเจนอีกครั้ง
//โดยทุกอย่่างจะเหมือนหน้าhoteldetailแต่จะไม่มีปุ่มไปต่อ ถ้าไม่เหมือนหน้า hoteldetail ต้องแก้
class HotelDetailPage extends StatefulWidget {
  final int hotelId;

  HotelDetailPage({required this.hotelId});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  appDatabase db = appDatabase();
  late Future<HotelModel?> _futureHotel;
  @override
  void initState() {
    super.initState();
    _futureHotel = db.getHotelDetailById(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Hotel Detail'),
        shadowColor: Colors.black,
      ),
      body: FutureBuilder<HotelModel?>(
        future: _futureHotel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            HotelModel hotel = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            '${hotel.img}',
                            fit: BoxFit.cover,
                            width: 350,
                            height: 250,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${hotel.name}',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Color(0xFF7a2ed6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                child: Text(
                                  hotel.ratings.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_sharp),
                                Text(
                                  'Address : '
                                  '${hotel.address}'
                                  '${hotel.city}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: Text(
                      'Start at : ${hotel.lowest} per night',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        roomAmenitiesModalBottomSheet(context, widget.hotelId);
                      },
                      child: Text(
                        'See all amenities',
                        style: TextStyle(color: Colors.blue),
                      ),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 15, 25, 5),
                    child: Text(
                      '${hotel.hotelDescription}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: Text(
                      'Location',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
                    child: Image.network(
                      //google map img
                      'https://i.stack.imgur.com/dApg7.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ],
              ),
            );
          } else {
            //check data
            return Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}

void roomAmenitiesModalBottomSheet(BuildContext context, int hotelId) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<List<FacilitiesHotel?>>(
        future: appDatabase().getFacById(hotelId),
        builder: (BuildContext context,
            AsyncSnapshot<List<FacilitiesHotel?>> snapshot) {
          if (snapshot.hasData) {
            List<FacilitiesHotel?> facilities = snapshot.data!;
            // check para has data
            // print('hotelId : ${hotelId}');
            // print('Facilities count: ${facilities.length}');
            // print(
            //     'First facility name: ${facilities.isNotEmpty ? facilities[0]?.facilities_name : "None"}');
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room Amenities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: facilities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(facilities[index]?.facilities_name ?? ''),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No amenities found.'));
          }
        },
      );
    },
  );
}

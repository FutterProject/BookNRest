import 'dart:async';

import 'package:book_and_rest/hotelPreferences.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/pages/roomdetail.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'database.dart';

class HotelDetail extends StatefulWidget {
  final int hotelId;
  //if error check this
  HotelDetail({required this.hotelId});

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  // Completer<GoogleMapController> _controller = Completer();
  appDatabase db = appDatabase();
  late Future<HotelModel?> _futureHotel;
  bool? isFavorited;
  int? userId;
  int? hotelId;
  String? hotelName;
  String? hotelImg;
  @override
  void initState() {
    super.initState();
    _futureHotel = db.getHotelDetailById(widget.hotelId);
    print("Hotel ID: ${widget.hotelId}");
    // hotelId = widget.hotelId;
    // hotelImg = widget
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserPreferences.getUserId();
    print("User ID : $userId");
    setState(() {});
  }

  void setPref(int hId, String hName, String hImg) async {
    hotelId = await HotelPreferences.setHotelId(hId);
    hotelName = await HotelPreferences.setHotelName(hName);
    hotelImg = await HotelPreferences.setHotelImg(hImg);
  }

  Future<bool> checkFavorite(int userId, int hotelId) async {
    return await db.checkFavorite(userId, hotelId);
  }

  void toggleFavorite(Map data) async {
    FavoriteHotel dataModel = FavoriteHotel(
      userId: data['userId'],
      hotelId: data['hotelId'],
    );

    if (isFavorited!) {
      await db.removeFavHotels(dataModel);
    } else {
      await db.addFavHotels(dataModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actions: [
          if (userId != null)
            FutureBuilder<bool>(
              future: checkFavorite(userId!, widget.hotelId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  isFavorited = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () async {
                      Map data = {
                        'userId': userId,
                        'hotelId': widget.hotelId,
                      };
                      toggleFavorite(data);
                      print("test => $data");
                      setState(() {
                        isFavorited = !isFavorited!;
                      });
                    },
                    icon: Icon(
                        isFavorited! ? Icons.favorite : Icons.favorite_border),
                  );
                }
              },
            ),
        ],
        title: Text('Hotel Detail'),
        shadowColor: Colors.black,
      ),
      body: FutureBuilder<HotelModel?>(
        future: _futureHotel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            HotelModel hotel = snapshot.data!;
            double lat = double.parse(hotel.lat!);
            double long = double.parse(hotel.long!);
            //set Pref for Hotel
            if (hotel.id != null) setPref(hotel.id!, hotel.name, hotel.img);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_sharp),
                                SizedBox(
                                    width: 250,
                                    child: Container(
                                      child: Text(
                                        'Address : '
                                        '${hotel.address} '
                                        '${hotel.city}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 70),
                    child: Container(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, long),
                          zoom: 15,
                        ),
                        markers: Set<Marker>.of([
                          Marker(
                            markerId: MarkerId('hotel_location'),
                            position: LatLng(lat, long),
                            infoWindow: InfoWindow(title: 'Hotel Location'),
                          ),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data'),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: 0,
          height: 40,
          child: FittedBox(
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomDetail(
                      hotelId: widget.hotelId,
                    ),
                  ),
                );
              },
              label: Text(
                'See all rooms',
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

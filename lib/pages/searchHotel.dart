import 'dart:math';

import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/filter.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SearchHotel extends StatefulWidget {
  const SearchHotel({super.key});

  @override
  State<SearchHotel> createState() => _SearchHotel();
}

class _SearchHotel extends State<SearchHotel> {
  late List data;
  // String? filtered;
  List<int>? filtered;
  Map<String, dynamic>? result;
  appDatabase db = appDatabase();
  String orderBy = 'nearest';
  double? myLat, myLong, hotelLat, hotelLong;
  String? distanceString;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as List;
    return Scaffold(
      appBar: AppBar(title: Text("Search Hotels")),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 800),
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Filter()));
                    setState(() {});
                    print('===Test : $filtered');
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Text(
                      'Filter',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _sortFunction();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
// borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text('Sort by', style: TextStyle(fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nearestFunction();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
// borderRadius: BorderRadius.circular(10.0),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: Text('Nearest', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            _buildFiltered(),
          ],
        ),
      ),
    );
  }

  Future _sortFunction() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text('Price: low to high'),
                  onTap: () {
                    // ทำการเรียงลำดับตามราคาจากน้อยไปมากที่นี่
                    setState(() {
                      orderBy = 'Price: low to high';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.arrow_downward),
                  title: Text('Price: high to low'),
                  onTap: () {
                    // ทำการเรียงลำดับตามราคาจากมากไปน้อยที่นี่
                    setState(() {
                      orderBy = 'Price: high to low';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text('Popularity: low to high'),
                  onTap: () {
                    // ทำการเรียงลำดับตามความนิยมจากน้อยไปมากที่นี่
                    setState(() {
                      orderBy = 'Popularity: low to high';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.arrow_downward),
                  title: Text('Popularity: high to low'),
                  onTap: () {
                    // ทำการเรียงลำดับตามความนิยมจากมากไปน้อยที่นี่
                    setState(() {
                      orderBy = 'Popularity: high to low';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future nearestFunction() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text('Distance'),
                  onTap: () {
                    setState(() {
                      orderBy = 'nearest';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.arrow_downward),
                  title: Text('Distance'),
                  onTap: () {
                    setState(() {
                      orderBy = 'farthest';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
    // var myFormat = NumberFormat('##.0#', 'en_US');
    // distanceString = myFormat.format(distance);

    return distance;
  }

  Widget _buildFiltered() {
    print("buildFilter working....");
    return FutureBuilder<List<HotelAllModel>>(
      future:
          db.getAvailableHotelsWithFilter(data[1], data[2], data[0], result),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          print('Stack trace: ${snapshot.stackTrace}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<HotelAllModel> hotels = snapshot.data!;
          // เรียงลำดับตามที่ผู้ใช้เลือก
          if (orderBy == 'Price: low to high') {
            hotels.sort((a, b) => a.min_price.compareTo(b.min_price));
          } else if (orderBy == 'Price: high to low') {
            hotels.sort((a, b) => b.min_price.compareTo(a.min_price));
          } else if (orderBy == 'Popularity: low to high') {
            // ทำการเรียงลำดับตามความนิยมจากน้อยไปมากที่นี่
            hotels.sort((a, b) => a.ratings.compareTo(b.ratings));
          } else if (orderBy == 'Popularity: high to low') {
            // ทำการเรียงลำดับตามความนิยมจากมากไปน้อยที่นี่
            hotels.sort((a, b) => b.ratings.compareTo(a.ratings));
          }
          for (var hotel in hotels) {
            hotelLat = double.parse(hotel.lat);
            hotelLong = double.parse(hotel.long);
            var displacement =
                calculateDistance(data[3], data[4], hotelLat!, hotelLong!);
            var myFormat = NumberFormat('#0.0#', 'en_US');
            distanceString = myFormat.format(displacement);
            print('== hotel "${hotel.name}" displacement "$displacement"');
            print('== hotel "${hotel.name}" distanceString "$distanceString"');
            hotel.displacement = double.parse(distanceString!);
            print(
                'myLat : ${data[3]} | myLong : ${data[4]} ==== hotelLat : ${hotelLat} | hotelLong : ${hotelLong}');
          }
          if (orderBy == 'nearest') {
            hotels.sort((a, b) => a.displacement!.compareTo(b.displacement!));
          } else if (orderBy == 'farthest') {
            hotels.sort((a, b) => b.displacement!.compareTo(a.displacement!));
          }
          return SizedBox(
            height: 800,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                HotelAllModel hotel = snapshot.data![index];
                return Card(
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
                        '${hotel.img}',
                        width: 150,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Symbols.location_on,
                                  color: Colors.grey,
                                ),
                                // Text(hotel.address),
                                Text('${hotel.displacement.toString()} km.'),
                                const Spacer(),
                                Icon(
                                  Symbols.star,
                                  color: Colors.yellow,
                                  fill: 1,
                                ),
                                Text(hotel.ratings.toString())
                                // Text("5")
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${hotel.min_price}',
                                  // '\$80',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  '/night',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ));
              },
            ),
          );
        } else {
          return const Center(child: Text('No hotels available'));
        }
        // แสดงตัวโหลดขณะรอข้อมูล
      },
    );
  }
}

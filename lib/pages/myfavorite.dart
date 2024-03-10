<<<<<<< HEAD
import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
=======
import 'package:flutter/material.dart';
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  State<MyFavorite> createState() => _MyFavorite();
}

<<<<<<< HEAD
appDatabase db = appDatabase();

class _MyFavorite extends State<MyFavorite> {
  int? userId;
  void initState() {
    super.initState();
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Favorite")),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 800),
        child: Center(
          child: _buildMyFavorite(),
        ),
      ),
    );
  }

  Widget _buildMyFavorite() {
    if (userId == null) {
      // return const Center(
      //     child: Text('กรุณาเข้าสู่ระบบเพื่อแสดงรายการโปรดของคุณ'));
      return const Center(child: CircularProgressIndicator());
    } else {
      return FutureBuilder<List<HotelModel>>(
        future: db.getFavoriteHotel(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            print('Stack trace: ${snapshot.stackTrace}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  HotelModel hotel = snapshot.data![index];
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
                                  Text(
                                    '${hotel.city}',
                                    // hotel.city,
                                    maxLines: 1,
                                  ),
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
            return const Center(child: Text('ยังไม่มีโรงแรมที่กดถูกใจ'));
          }
        },
      );
    }
=======
class _MyFavorite extends State<MyFavorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
  }
}

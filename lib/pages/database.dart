import 'package:book_and_rest/pages/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class appDatabase {
  static Database? _database;

  Future<Database> initializedb() async {
    if (_database == null) _database = await createdb();
    return _database!;
  }

  Future<Database> createdb() async {
    final path = await getDatabasesPath();
    var database = await openDatabase(join(path, 'hotelDB.db'), version: 1,
        onCreate: ((db, version) async {
      await db.execute('''
    CREATE TABLE Hotels (
      hotel_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      address TEXT,
      city TEXT,
      ratings REAL,
      img TEXT,
      lat TEXT,
      long TEXT,
      displacement REAL,
      lowest INTEGER NULL,
      hotel_description TEXT
    )
  ''');
      await db.execute('''
    CREATE TABLE Rooms (
      room_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      room_number TEXT,
      type TEXT,
      price REAL,
      hotel_id INTEGER,
      room_img TEXT,
      adult INTEGER,
      child INTEGER,
      room_description TEXT,
      FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
    )
  ''');
      await db.execute('''
    CREATE TABLE Users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      email TEXT
    )
  ''');
      await db.execute('''
    CREATE TABLE Bookings (
      booking_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      room_id INTEGER,
      user_id INTEGER,
      checkin_date DATE,
      checkout_date DATE,
      first_name TEXT, 
      last_name TEXT,
      email TEXT, 
      phone_number TEXT,
      FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');
      await db.execute('''
    CREATE TABLE Facilities (
      facilities_id INTEGER PRIMARY KEY,
      facilities_name TEXT
    )
  ''');
      await db.execute('''
    CREATE TABLE HotelFacilities (
      hotel_id INTEGER,
      facilities_id INTEGER,
      FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id),
      FOREIGN KEY (facilities_id) REFERENCES Facilities(facilities_id),
      PRIMARY KEY (hotel_id,facilities_id)
    )
  ''');
      // เพิ่มข้อมูลลงในตาราง
      await db.rawInsert('''
    INSERT INTO Hotels (hotel_id, name, address, city, ratings , img, lat, long, displacement,lowest , hotel_description)
    VALUES (1, 'Hotel A', '123 Main St.', 'bangkok' , '4.2', 'https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=450x450', '13.113493', '100.922488', 1 ,NULL ,"The Jianguo Hotel Qianmen is located near Tiantan Park, just a 10-minute walk from the National Center for the Performing Arts and Tian'anmen Square. Built in 1956 it has old school charm and many rooms still feature high, crown-molded ceilings. A 2012 renovation brought all rooms and services up to modern day scratch and guestrooms come equipped with free Wi-Fi and all the usual amenities required for a comfortable stay."),
           (2, 'Hotel B', '456 Elm St.', 'chon buri', '4.5', 'https://pix8.agoda.net/hotelImages/2011272/-1/826c738efa75af641b8ff780c1ac62bc.jpg?ce=0&s=450x450', '13.11476', '100.92624', 1,NULL,"Kai Heng Century Hotel offers ultimate comfort and luxury. This 4-storied hotel is a beautiful combination of traditional grandeur and modern facilities. The 255 exclusive guest rooms are furnished with a range of modern amenities such as television and internet access. International direct-dial phone and safe are also available in any of these rooms. Wake-up call facility is also available in these rooms."),
           (3, 'Hotel C', '789 Elm St.', 'surin', '4.7', 'https://pix8.agoda.net/hotelImages/10859/-1/107b911e9ca63bb87d2747df2b6ad8bd.jpg?ca=14&ce=1&s=450x450', '13.116296', '100.914315', 1,NULL,"Monteverde Country Lodge is a quiet, comfortable hotel located near the Ecological Sanctuary and the Monteverde Butterfly Gardens in an area called Cerro Plano, an ideal location half way between the Monteverde Cloud Forest reserve and the main village of the Monteverde area (Santa Elena), in close proximity to several restaurants and activities. All rooms have private bathrooms with hot water."),
           (4, 'Centara Life Maris Resort', '94 najomtian R.', 'bangkok', '4.8', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/29/14/a2/13/swimming-pool-3.jpg?w=300&h=300&s=1', '13.12430', '100.91681', 1 ,NULL,"Ibis London Wembley hotel is in close proximity to Wembley Stadium and Wembley Arena, both just a few minutes walk from the hotel. Each of the 210 modern guest rooms have wireless internet and satellite TV. The hotel has excellent local transport connections into central London."),
           (5, 'Avani Pattaya Resort', '21/8 Liebchayhad R. ', 'bangkok', '4.9', 'https://pix8.agoda.net/hotelImages/10859/-1/107b911e9ca63bb87d2747df2b6ad8bd.jpg?ca=14&ce=1&s=450x450', '13.10594', '100.91458', 1 , NULL ,"Only 20 minutes by tube from London's bustling West End, Ibis London Earls Court puts you close to plenty of prominent nearby attractions including the Olympia Conference Centre, Hyde Park, Knightsbridge and Kensington's thriving high street and business district. Inviting, modern and cozy, with a comfortable bed and a functional bathroom, everything you need for a pleasant stay.")
  ''');
      await db.rawInsert('''
    INSERT INTO Rooms (room_id, room_number, type, price, hotel_id , room_img , adult , child , room_description)
    VALUES (101, '101', 'Single', 79.00, 1 , 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1' , 2 , 1 , 'Our king size four poster provides views over landscaped gardens. It has a seating area, ample storage, digital safe and mini fridge.'),
           (102, '102', 'Double', 89.00, 1 , 'https://images.pexels.com/photos/262048/pexels-photo-262048.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 2 , 1 , 'Our king size sleigh bedded also provides views over landscaped gardens. It has ample storage, a seating area, digital safe and mini fridge.'),
           (201, '201', 'Suite', 20.00, 2 , 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1' , 2 , 1 , 'Our Deluxe king size room has a seating area, ample storage, digital safe and mini fridge. This room can also be configured with an extra roll-away bed for families of 3.'),
           (202, '202', 'Deluxe', 49.00, 2 , 'https://images.pexels.com/photos/210265/pexels-photo-210265.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 2 , 1 , 'Our Deluxe Twin/Large Double also provides views over landscaped gardens. It has a seating area, digital safe and mini fridge. This room can be configured with either 2 single beds or zip and linked to provide a large double bed.'),
           (301, '301', 'Single', 50.00, 3 , 'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1' , 2 , 1 , 'As our smallest budget rooms, the Compact bedrooms are suited for single occupancy or short-stay double occupancy as they have limited space and storage.'),
           (302, '302', 'Deluxe', 60.00, 3 , 'https://images.pexels.com/photos/271643/pexels-photo-271643.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1' , 2 , 1 , 'Our king size four poster provides views over landscaped gardens. It has a seating area, ample storage, digital safe and mini fridge.'),
           (401, '401', 'Single', 79.00, 4 , 'https://images.pexels.com/photos/210604/pexels-photo-210604.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1' , 2 , 1 ,'Our Deluxe king size room has a seating area, ample storage, digital safe and mini fridge. This room can also be configured with an extra roll-away bed for families of 3.'),
           (501, '501', 'Deluxe', 99.00, 5 , 'https://images.pexels.com/photos/279746/pexels-photo-279746.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1' , 2 , 1 ,'Our king size four poster provides views over landscaped gardens. It has a seating area, ample storage, digital safe and mini fridge.')
  ''');
      await db.rawInsert('''
    INSERT INTO Bookings (booking_id, room_id, user_id, checkin_date, checkout_date ,first_name , last_name ,email , phone_number)
    VALUES (1, 101, 1001, '2024-02-01', '2024-02-03', NULL , NULL ,NULL ,NULL),
           (2, 201, 1002, '2024-02-05', '2024-02-08',NULL , NULL , NULL ,NULL),
           (3, 301, 1002, '2024-02-10', '2024-02-12',NULL ,NULL ,NULL ,NULL)
  ''');
      await db.rawInsert('''
    INSERT INTO Users (user_id, name, email)
    VALUES (1001, 'John', 'john@example.com'),
           (1002, 'Alice', 'alice@example.com')
  ''');
      await db.rawInsert('''
    INSERT INTO Facilities (facilities_id, facilities_name) 
    VALUES (1, 'ห้องน้ำ'),
            (2, 'แอร์'),
            (3, 'WiFi'),
            (4, 'ทีวี'),
            (5, 'ฟิตเนส')
  ''');
      await db.rawInsert('''
    INSERT INTO HotelFacilities (hotel_id, facilities_id)
    VALUES (1, 1),
          (1, 2),
          (2, 1),
          (3, 3),
          (4, 1),
          (4, 2),
          (5, 1)
  ''');
    }));
    return database;
  }

  Future insertData(HotelModel model) async {
    var db = await initializedb();
    var result = await db.insert('Hotels', model.toMap());
    print("insert success");
    return result;
  }

  Future<List<HotelModel>> getAllData() async {
    var db = await initializedb();
    List<Map<String, dynamic>> result = await db.query('Hotels');
    return List.generate(
      result.length,
      (index) => HotelModel(
        id: result[index]['id'],
        name: result[index]['name'],
        address: result[index]['address'],
        city: result[index]['city'],
        img: result[index]['img'],
        lowest: result[index]['lowest'],
        hotelDescription: result[index]['hotel_description'],
        ratings: result[index]['ratings'],
      ),
    );
  }

  Future<List<HotelModel>> getData(String keyword) async {
    var db = await initializedb();
    List<Map<String, dynamic>> result =
        // await db.query('hotels', where: 'id=?', whereArgs: [itemId]);
        await db.rawQuery(
      'SELECT * FROM Hotels WHERE name LIKE ? OR address LIKE ? OR city LIKE ?',
      ['%$keyword%', '%$keyword%', '%$keyword%'],
    );
    return List.generate(
      result.length,
      (index) => HotelModel(
        id: result[index]['id'],
        name: result[index]['name'],
        address: result[index]['address'],
        city: result[index]['city'],
        img: result[index]['img'],
        lowest: result[index]['lowest'],
        hotelDescription: result[index]['hotel_description'],
        ratings: result[index]['ratings'],
      ),
    );
  }

  Future<List<RoomAvalibleModel>> getAvailableRooms(
      String wantSearch, String wantCheckIn, String wantCheckOut) async {
    var db = await initializedb();
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT r.room_id, r.room_number, r.type, r.price, r.hotel_id, h.name, h.address, h.city, h.img
    FROM Rooms r
    JOIN Hotels h ON r.hotel_id = h.hotel_id
    WHERE r.room_id NOT IN (
        SELECT b.room_id
        FROM Bookings b
        WHERE (
            (b.checkin_date <= ? AND b.checkout_date > ?)
            OR (b.checkin_date < ? AND b.checkout_date >= ?)
            OR (b.checkin_date >= ? AND b.checkout_date <= ?)
        )
    )
    AND h.city = ?
    ''',
      [
        wantCheckIn,
        wantCheckIn,
        wantCheckOut,
        wantCheckOut,
        wantCheckIn,
        wantCheckOut,
        wantSearch
      ],
    );
    print("Select Success");
    print('Result from database query on Avalible: $result');
    return List.generate(
      result.length,
      (index) => RoomAvalibleModel(
        roomId: result[index]['room_id'],
        roomNumber: result[index]['room_number'],
        type: result[index]['type'],
        price: result[index]['price'],
        hotelId: result[index]['hotel_id'],
        name: result[index]['name'],
        address: result[index]['address'],
        city: result[index]['city'],
        img: result[index]['img'],
      ),
    );
  }

  Future<List<HotelAvalibleModel>> getAvailableHotels(
      String wantSearch, String wantCheckIn, String wantCheckOut) async {
    var db = await initializedb();
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT r.hotel_id, h.name, h.address, h.city, h.img, h.ratings, MIN(r.price) as min_price
    FROM Rooms r
    JOIN Hotels h ON r.hotel_id = h.hotel_id
    WHERE r.room_id NOT IN (
        SELECT b.room_id
        FROM Bookings b
        WHERE (
            (b.checkin_date <= ? AND b.checkout_date > ?)
            OR (b.checkin_date < ? AND b.checkout_date >= ?)
            OR (b.checkin_date >= ? AND b.checkout_date <= ?)
        )
    )
    AND h.city = ?
    GROUP BY r.hotel_id, h.name, h.address, h.city, h.img, h.ratings
    ''',
      [
        wantCheckIn,
        wantCheckIn,
        wantCheckOut,
        wantCheckOut,
        wantCheckIn,
        wantCheckOut,
        wantSearch
      ],
    );
    print("Select Success");
    print('Result from database query on Avalible: $result');
    return List.generate(
      result.length,
      (index) => HotelAvalibleModel(
        hotelId: result[index]['hotel_id'],
        name: result[index]['name'],
        address: result[index]['address'],
        city: result[index]['city'],
        img: result[index]['img'],
        ratings: result[index]['ratings'],
        min_price: result[index]['min_price'],
      ),
    );
  }

  Future<List<RoomModel>> showAllRoom() async {
    var db = await initializedb();
    List<Map<String, dynamic>> result = await db.query('Rooms');
    print('Result from database query: $result');
    return List.generate(
      result.length,
      (index) => RoomModel(
        roomId: result[index]['room_id'],
        roomNumber: result[index]['room_number'],
        type: result[index]['type'],
        price: result[index]['price'],
        hotelId: result[index]['hotel_id'],
        roomImg: result[index]['room_img'],
        adult: result[index]['adult'],
        child: result[index]['child'],
        roomDescription: result[index]['room_descriptipn'],
      ),
    );
  }

  //ใช้ใน filter Facilities
  Future<List<FacilitiesHotel>> getFacilities() async {
    var db = await initializedb();
    List<Map<String, dynamic>> result = await db.query('Facilities');
    print('Result from database query: $result');
    // return List.generate(
    //   result.length,
    //   (index) => FacilitiesHotel(
    //     facilities_id: result[index]['facilities_id'],
    //     facilities_name: result[index]['facilities_name'],
    //     isChecked: false,
    //   ),
    // );
    return List.generate(result.length, (i) {
      return FacilitiesHotel.fromMap(result[i]);
    });
  }

  //real
  Future<List<HotelModel>> filterHotels(String selectedFacilityIds) async {
    // ดึงข้อมูลโรงแรมที่มีสิ่งอำนวยความสะดวกเหล่านี้จากฐานข้อมูล
    var db = await initializedb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT Hotels.* , COUNT(HotelFacilities.facilities_id) as facility_count
    FROM Hotels
    JOIN HotelFacilities ON Hotels.hotel_id = HotelFacilities.hotel_id
    WHERE HotelFacilities.facilities_id IN ($selectedFacilityIds)
    GROUP BY Hotels.hotel_id
    HAVING facility_count = LENGTH('$selectedFacilityIds') - LENGTH(REPLACE('$selectedFacilityIds', ',', '')) + 1
  ''');
    // แปลง List<Map<String, dynamic>> เป็น List<Hotel>
    return List.generate(maps.length, (i) {
      return HotelModel.fromMap(maps[i]);
    });
  }

  Future<List<HotelAllModel>> getAvailableHotelsWithFilter(
      String wantCheckIn, String wantCheckOut,
      [String? destination, Map<String, dynamic>? result]) async {
    var db = await initializedb();
    List<int> selectedFacilityIds = result?['selectedFacilityIds'] ?? [];

    final List<Map<String, dynamic>> findMaxMinPrice = await db.rawQuery('''
      SELECT MIN(price) as min_price, MAX(price) as max_price
      FROM Rooms
      ''');
    int startRangeValue =
        result?['startRangeValue'] ?? findMaxMinPrice[0]['min_price'].toInt();
    int endRangeValue =
        result?['endRangeValue'] ?? findMaxMinPrice[0]['max_price'].toInt();
    print('start : $startRangeValue');
    print('end : $endRangeValue');
    print("FA ID : $selectedFacilityIds");
    //เงื่อนไข ถ้ามีการเลือกจุดหมาย
    String cityCondition =
        destination != null ? 'AND h.city = "$destination"' : '';

    // กำหนดจำนวน ? เพื่อให้ สามารถแทนด้วย argument ได้ตามจำนวน id ที่มี
    String facilityIdPlaceholders =
        selectedFacilityIds.map((_) => '?').join(',');
    print("FAHOLDER : $facilityIdPlaceholders");
    // ตรวจสอบว่า facilities ที่เลือกต้องมีทั้งหมดที่กำหนด
    String havingClause = selectedFacilityIds.isNotEmpty
        ? 'HAVING COUNT(DISTINCT hf.facilities_id) = ${selectedFacilityIds.length}'
        : '';
    // String havingClause =
    //     'HAVING COUNT(DISTINCT hf.facilities_id) = ${selectedFacilityIds.length}';
    print('HAVING : $havingClause');

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT r.hotel_id, h.name, h.address, h.city, h.img, h.ratings, MIN(r.price) as min_price, h.lat, h.long, h.displacement
      FROM Rooms r
      JOIN Hotels h ON r.hotel_id = h.hotel_id
      JOIN HotelFacilities hf ON h.hotel_id = hf.hotel_id
      WHERE r.room_id NOT IN (
          SELECT b.room_id
          FROM Bookings b
          WHERE (
              (b.checkin_date <= ? AND b.checkout_date > ?)
              OR (b.checkin_date < ? AND b.checkout_date >= ?)
              OR (b.checkin_date >= ? AND b.checkout_date <= ?)
          )
      )
      $cityCondition
      --AND h.city = ?
      ${selectedFacilityIds.isNotEmpty ? 'AND hf.facilities_id IN ($facilityIdPlaceholders)' : ''}
      AND r.price BETWEEN $startRangeValue AND $endRangeValue
      GROUP BY r.hotel_id, h.name, h.address, h.city, h.img, h.ratings

      ${havingClause.isNotEmpty ? havingClause : ''}
      ''',
      [
        wantCheckIn,
        wantCheckIn,
        wantCheckOut,
        wantCheckOut,
        wantCheckIn,
        wantCheckOut,
        // destination,
        ...selectedFacilityIds,
      ],
    );
    print("Select Success");
    print('Result from database query on Avalible: $maps');
    return List.generate(
      maps.length,
      (index) => HotelAllModel(
        hotelId: maps[index]['hotel_id'],
        name: maps[index]['name'],
        address: maps[index]['address'],
        city: maps[index]['city'],
        img: maps[index]['img'],
        ratings: maps[index]['ratings'],
        min_price: maps[index]['min_price'],
        lat: maps[index]['lat'],
        long: maps[index]['long'],
        displacement: maps[index]['displacement'],
      ),
    );
  }

  Future<HotelModel?> getHotelDetailById(int hotelId) async {
    Database database = await openDatabase('hotelDB.db');
    List<Map<String, dynamic>> result = await database.rawQuery(
      // 'SELECT * FROM Hotels h WHERE h.hotel_id = ?',
      //----
      '''SELECT h.hotel_id , h.name , h.address , h.city , h.img , MIN(r.price) as lowest , h.hotel_description , h.ratings
      FROM Hotels h
      JOIN Rooms r on r.hotel_id = h.hotel_id
      WHERE h.hotel_id = ?
      GROUP BY h.name , h.address , h.city''',
      //---
      [hotelId],
    );

    if (result.isNotEmpty) {
      return HotelModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<RoomModel?>> getRoomDetailById(int hotelId) async {
    Database database = await openDatabase('hotelDB.db');
    List<Map<String, dynamic>> result = await database.rawQuery(
      ''' SELECT r.room_id , r.room_number , r.type , r.price , r.hotel_id, r.room_img ,r.adult , r.child , r.room_description
          FROM Rooms r
          JOIN Hotels h on h.hotel_id = r.hotel_id
          WHERE r.hotel_id = ? ''',
      [hotelId],
    );
    List<RoomModel?> rooms = [];
    for (var item in result) {
      rooms.add(RoomModel.fromMap(item));
    }
    return rooms;
  }

  Future<List<FacilitiesHotel?>> getFacById(int hotelId) async {
    Database database = await openDatabase('hotelDB.db');
    List<Map<String, dynamic>> result = await database.rawQuery(
      ''' 
    SELECT f.facilities_id, f.facilities_name 
    FROM Facilities f
    JOIN HotelFacilities hf ON f.facilities_id = hf.facilities_id
    WHERE hf.hotel_id = ?
    ''',
      [hotelId],
    );
    List<FacilitiesHotel?> fac = result
        .map((map) => FacilitiesHotel(
              facilities_id: map['facilities_id'],
              facilities_name: map['facilities_name'],
            ))
        .toList();
    return fac;
  }
}

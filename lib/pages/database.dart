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
    var database = await openDatabase(join(path, 'hotelDB.db'), version: 2,
        onCreate: ((db, version) async {
      await db.execute('''
    CREATE TABLE Hotels (
      hotel_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      address TEXT,
      city TEXT,
      img TEXT
    )
  ''');
      await db.execute('''
    CREATE TABLE Rooms (
      room_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      room_number TEXT,
      type TEXT,
      price REAL,
      hotel_id INTEGER,
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
      FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
    )
  ''');

      // เพิ่มข้อมูลลงในตาราง
      await db.rawInsert('''
    INSERT INTO Hotels (hotel_id, name, address, city, img)
    VALUES (1, 'Hotel A', '123 Main St.', 'bangkok', 'https://pix8.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?ca=6&ce=1&s=450x450'),
           (2, 'Hotel B', '456 Elm St.', 'chon buri', 'https://pix8.agoda.net/hotelImages/2011272/-1/826c738efa75af641b8ff780c1ac62bc.jpg?ce=0&s=450x450'),
           (3, 'Hotel C', '789 Elm St.', 'surin', 'https://pix8.agoda.net/hotelImages/10859/-1/107b911e9ca63bb87d2747df2b6ad8bd.jpg?ca=14&ce=1&s=450x450')
  ''');
      await db.rawInsert('''
    INSERT INTO Rooms (room_id, room_number, type, price, hotel_id)
    VALUES (101, '101', 'Single', 100.00, 1),
           (102, '102', 'Double', 150.00, 1),
           (201, '201', 'Suite', 250.00, 2),
           (202, '202', 'Deluxe', 250.00, 2),
           (301, '301', 'Single', 250.00, 3),
           (302, '302', 'Single', 250.00, 3)
  ''');
      await db.rawInsert('''
    INSERT INTO Bookings (booking_id, room_id, user_id, checkin_date, checkout_date)
    VALUES (1, 101, 1001, '2024-02-01', '2024-02-03'),
           (2, 201, 1002, '2024-02-05', '2024-02-08'),
           (3, 201, 1002, '2024-02-10', '2024-02-12')
  ''');
      await db.rawInsert('''
    INSERT INTO Users (user_id, name, email)
    VALUES (1001, 'John', 'john@example.com'),
           (1002, 'Alice', 'alice@example.com')
  ''');
    }));
    // final tables =
    //     await database.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    // print(tables);
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
      ),
    );
  }

  Future<List<RoomModel>> getAvailableRooms(
      String wantSearch, String wantCheckIn, String wantCheckOut) async {
    var db = await initializedb();
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT r.room_id, r.room_number, r.type, r.price, r.hotel_id
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
      (index) => RoomModel(
        roomId: result[index]['room_id'],
        roomNumber: result[index]['room_number'],
        type: result[index]['type'],
        price: result[index]['price'],
        hotelId: result[index]['hotel_id'],
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
      ),
    );
  }
}

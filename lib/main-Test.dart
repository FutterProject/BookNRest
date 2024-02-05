import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Database>? database;

  @override
  void initState() {
    super.initState();
    database = initializeDb();
  }

  Future<Database> initializeDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'hotel_booking.db'),
      onCreate: (db, version) async {
        // Create tables
        await db.execute("CREATE TABLE Rooms ("
            "room_id INTEGER PRIMARY KEY, "
            "hotel_id INTEGER, "
            "room_type TEXT)");
        await db.execute("CREATE TABLE Hotels ("
            "hotel_id INTEGER PRIMARY KEY, "
            "hotel_name TEXT, "
            "hotel_location TEXT)");
        await db.execute("CREATE TABLE Users ("
            "user_id INTEGER PRIMARY KEY, "
            "user_name TEXT, "
            "user_email TEXT)");
        await db.execute("CREATE TABLE Bookings ("
            "booking_id INTEGER PRIMARY KEY, "
            "room_id INTEGER, "
            "user_id INTEGER, "
            "checkin_date TEXT, "
            "checkout_date TEXT)");

        // Insert initial data
        await db.insert(
            'Rooms', {'room_id': 1, 'hotel_id': 1, 'room_type': 'Deluxe'});
        await db.insert(
            'Rooms', {'room_id': 2, 'hotel_id': 1, 'room_type': 'Deluxe'});
        await db.insert(
            'Rooms', {'room_id': 3, 'hotel_id': 2, 'room_type': 'Deluxe'});
        await db.insert('Hotels', {
          'hotel_id': 1,
          'hotel_name': 'Hotel California',
          'hotel_location': 'Los Angeles'
        });
        await db.insert('Hotels', {
          'hotel_id': 2,
          'hotel_name': 'Hotel New York',
          'hotel_location': 'New York'
        });
        await db.insert('Users', {
          'user_id': 1,
          'user_name': 'John Doe',
          'user_email': 'john.doe@example.com'
        });
        await db.insert('Bookings', {
          'booking_id': 1,
          'room_id': 1,
          'user_id': 1,
          'checkin_date': '2024-02-03',
          'checkout_date': '2024-02-05'
        });
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book&Rest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Rooms'),
                  Tab(text: 'Hotels'),
                  Tab(text: 'Users'),
                  Tab(text: 'Bookings'),
                ],
              ),
              title: Text('Hotel Booking Database'),
            ),
            body: TabBarView(
              children: [
                _buildDataTable('Rooms'),
                _buildDataTable('Hotels'),
                _buildDataTable('Users'),
                _buildDataTable('Bookings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(String tableName) {
    return FutureBuilder(
      future: database,
      builder: (context, AsyncSnapshot<Database> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: snapshot.data!.query(tableName),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      // title: Text('Name'),
                      title: Text(
                          '$tableName ID: ${snapshot.data![index]['${tableName.substring(0, tableName.length - 1).toLowerCase()}_id']}'),
                      subtitle: Text(snapshot.data![index].toString()),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

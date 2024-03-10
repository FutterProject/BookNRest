import 'package:book_and_rest/pages/home.dart';
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
<<<<<<< HEAD
      userId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      userName TEXT,
      userEmail TEXT,
      userPass TEXT,
      address TEXT,
      role INTEGER
    )
  ''');
      await db.execute('''
        CREATE TABLE Roles (
          RoleId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          RoleName TEXT
        )
      ''');
      await db.execute('''
    CREATE TABLE Bookings (
      booking_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      room_id INTEGER,
      userId INTEGER,
=======
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
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
      checkin_date DATE,
      checkout_date DATE,
      first_name TEXT, 
      last_name TEXT,
      email TEXT, 
      phone_number TEXT,
      FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
<<<<<<< HEAD
      FOREIGN KEY (userId) REFERENCES Users(userId)
=======
      FOREIGN KEY (user_id) REFERENCES Users(user_id)
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
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
      await db.execute('''
    CREATE TABLE BookingDetail(
            bookingId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            hotelId INTEGER, 
            roomId INTEGER, 
            selectedRoomCount INTEGER, 
            firstName TEXT, 
            lastName TEXT, 
            email TEXT, 
            phone TEXT,
            checkInDate DATE,
<<<<<<< HEAD
            checkOutDate DATE,
            userId INT
            )
            ''');
      await db.execute('''
        CREATE TABLE FavoriteHotel (
          userId INTEGER,
          hotel_id INTEGER,
          PRIMARY KEY (userId,hotel_id)
        )
      ''');
      // เพิ่มข้อมูลลงในตาราง
      await db.rawInsert('''
    INSERT INTO Hotels (hotel_id, name, address, city, ratings , img, lat, long, displacement,lowest , hotel_description)
    VALUES (1, 'Star Sukhumvit', "369 Soi Sukhumvit 66/1", 'bangkok' , '4.2', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/261444497.jpg?k=180ebda3baedd217db9dfd6d79394d6a807e390550ed37889b85033b6320eea1&o=&hp=1', '13.682910651980714', '100.60562028226451', 1 , NULL ,"Situated in Bangkok, 5.2 km from Bangkok International Trade and Exhibition Centre BITEC, Star Sukhumvit features accommodation with free WiFi and free private parking. The property is around 10 km from Queen Sirikit National Convention Centre, 11 km from Central Embassy and 11 km from Mega Bangna. The property is non-smoking and is located 7.7 km from Emporium Shopping Mall."),
           (2, 'VIC 3 Bangkok Hotel', "89 Phahon Yothin Soi 3", 'bangkok', '4.5', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/533687646.jpg?k=c3791b8fc657034002c3bcd32a7d7d4405b0af031d5c899264b91737971ca135&o=&hp=1', '13.774471598004675', '100.54222188442915', 1, NULL,"Kai Heng Century Hotel offers ultimate comfort and luxury. This 4-storied hotel is a beautiful combination of traditional grandeur and modern facilities. The 255 exclusive guest rooms are furnished with a range of modern amenities such as television and internet access. International direct-dial phone and safe are also available in any of these rooms. Wake-up call facility is also available in these rooms."),
           (3, 'Don Muang Hotel', '5 Soi Saranakhom 3', 'bangkok', '4.7', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/86024983.jpg?k=6acfb628d7736b0dcb4c5e396a43951076c9d02c5c507c2ff4ce45dd0bd9f711&o=&hp=1', '13.925845502450308', '100.59846302459668', 1, NULL,"Don Muang Hotel is located in an Airport City just 800 meters walking distance to Don Mueang International Airport. Don Muang Hotel offers a scheduled airport shuttle van service with reasonable prices from 4:30 A.M. - 11:30 A.M. daily in the early morning. Hotels offer an Early Check-In that starts at 9 A.M. for our valued customer to take more rest, Free Wifi and Private Parking provided. Breakfast is available daily from 4 A.M. to 10 A.M. with a localization and continental breakfast styles In Room featuring with Air-Condition, Private bathroom with hot & cold shower facilities, A Slipper, Toiletries and Towels are provided free of charge. Don Muang Hotel is the best choice of your stay for a night and service to  your early flight to Don Mueang International Airport."),
           (4, 'Bangkok 68', '68 Soi Ratchada 17', 'bangkok', '4.8', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/45116072.jpg?k=d75f614e5cc7691c4b5ec68af406682a1c81a82f2a599b6d733193a9abc3c114&o=&hp=1', '13.786523060550037', '100.569473995758', 1 , NULL,"Located in Bangkok, Bangkok 68 offers comfortable rooms with air conditioning. Boasting an outdoor pool, this property has a 24-hour front desk. Free Wi-Fi is available throughout the residence. Bangkok 68 is within a 15-minute ride from Central Plaza Grand Rama 9 Mall. It is a 30-minute drive from Don Muang Airport and Suvarnabhumi Airport. On-site parking is available. Modern rooms are provided with a flat-screen cable TV and a refrigerator. An en suite bathroom comes with shower facilities. Some rooms offer a bathtub. For meals, head to local restaurants located within a 10-minute ride away."),
           (5, 'Siam Palace Hotel', '3 Soi Pradiphat 10', 'bangkok', '4.9', 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/190194337.jpg?k=b08a5196df42b9151745d7688bf2e5c0110169fd7059b27ecf0882275a936259&o=&hp=1', '13.79024373904735', '100.54210895157759', 1 , NULL ,"Well located in the Phaya Thai district of Bangkok, Siam Palace Hotel is located 2.8 km from Chatuchak Weekend Market, 4.5 km from Central Plaza Ladprao and 6 km from Siam Discovery. This 3-star hotel offers room service, a 24-hour front desk and free WiFi. The accommodation provides a concierge service, luggage storage space and currency exchange for guests. Guest rooms at the hotel are equipped with a seating area, a flat-screen TV with cable channels and a private bathroom with free toiletries and a bidet. All guest rooms at Siam Palace Hotel include air conditioning and a desk. Siam Paragon Mall is 6.4 km from the accommodation, while Gaysorn Village Shopping Mall is 6.8 km away. The nearest airport is Don Mueang International Airport, 18 km from Siam Palace Hotel."),
           (6, 'Marigold Sukhumvit' , '2009 Moo 6 Sukhumvit Rd', 'bangkok','4.5','https://cf.bstatic.com/xdata/images/hotel/max1024x768/244315856.jpg?k=58ed3e711949477bd9b0219310b9db78100853bddc6ee8496996587d8f60f83a&o=&hp=1','13.652599383328797', '100.59951002273891',1, NULL, "Located in Samutprakarn, a 13-minute walk from Samrong BTS Station, Marigold Sukhumvit offers a fitness centre and free bikes. This property features free WiFi, a garden and a terrace. Offering a private balcony with city views, rooms will provide you with a cable TV, a DVD player and air conditioning. An electric kettle and a seating area included. Featuring a shower, private bathroom also comes with a hairdryer and free toiletries. Suvarnabhumi Airport is only a 30-minute drive from the property."),
           (7, 'M CASA HOTEL PATTAYA' , '140/90 MOO11 NONGPRUE', 'chonburi','4.6','https://cf.bstatic.com/xdata/images/hotel/max1024x768/415671439.jpg?k=b73e08d90269afe79615848b96da8b7ea52e05fd9384d05bb0a5a91ecd78b84c&o=&hp=1','12.923755957451', '100.87342116875939',1,NULL, "Situated in Nong Prue, 700 metres from Pattaya Beach, M CASA HOTEL PATTAYA features accommodation with an outdoor swimming pool, free private parking, a terrace and a restaurant. With free WiFi, this 4-star hotel offers room service and a 24-hour front desk. The property is non-smoking and is set 2.3 km from Cosy Beach. The units in the hotel are equipped with a kettle. Complete with a private bathroom fitted with a shower and a hairdryer, the rooms at M CASA HOTEL PATTAYA have a flat-screen TV and air conditioning, and certain rooms come with a balcony. All units will provide guests with a fridge. The daily breakfast offers buffet, à la carte or American options. Paradise Beach is 2.4 km from the accommodation, while Bangpra International Golf Club is 42 km from the property. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 45 km from M CASA HOTEL PATTAYA."),
           (8, 'Sirin Exclusive Hotel' , '338/139 Moo.12 Pratumnak Soi 5', 'chonburi','4.1','https://cf.bstatic.com/xdata/images/hotel/max1024x768/463561092.jpg?k=bbfa20544da07552df0a562a894976036b929b22ad3903860ed8e680e906d742&o=&hp=1','12.912399053257516', '100.86207878039814',1,NULL, "Set in Pattaya South, 700 metres from Pratumnak Beach, Sirin Exclusive Hotel and Residence offers accommodation with an outdoor swimming pool, free private parking, a fitness centre and a garden. Offering a restaurant, the property also has a shared lounge, as well as a sauna and a hot tub. The accommodation features a 24-hour front desk, a shuttle service, room service and free WiFi. At the hotel all rooms include air conditioning, a seating area, a flat-screen TV with cable channels, a safety deposit box and a private bathroom with free toiletries and slippers. All guest rooms will provide guests with a desk and a kettle. Breakfast is available every morning, and includes buffet, à la carte and continental options. Sirin Exclusive Hotel and Residence offers a terrace. Popular points of interest near the accommodation include Paradise Beach, Dongtan Beach and Pattaya Viewpoint. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 47 km from Sirin Exclusive Hotel and Residence."),
           (9, 'Golden Tulip Pattaya' , '469, Moo.5, Naklua', 'chonburi','3.9','https://cf.bstatic.com/xdata/images/hotel/max1024x768/413209177.jpg?k=e17a27943a77058c0e06dc308a1e4ea8d24ec113d4d14161d0fe24c0ad1b7443&o=&hp=1','12.970462768989806', '100.88443637047497',1,NULL, "Set in Pattaya North, 500 metres from Wong Amat Beach, Golden Tulip Pattaya Beach Resort offers accommodation with an outdoor swimming pool, free private parking, a terrace and a restaurant. This 5-star hotel offers room service, a 24-hour front desk and free WiFi. The accommodation features evening entertainment and babysitting service. All rooms are fitted with a private bathroom, while selected rooms will provide you with a balcony and others also have a sea view. Popular points of interest near the hotel include Wong Prachan Beach, Naklua Beach and The Sanctuary of Truth. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 45 km from Golden Tulip Pattaya Beach Resort."),
           (10, 'Worita Cove Hotel' , '46/6 Moo 4, Najomtien', 'chonburi','4.8','https://cf.bstatic.com/xdata/images/hotel/max1024x768/158704106.jpg?k=39c5173342e30ff7a96b9718f1f244d5ace8285e08b57172695b5acdb3b908b6&o=&hp=1','12.816832210175987', '100.9126128821166',1,NULL, "Set in Na Jomtien, 600 metres from Ban Amphur Beach, Worita Cove Hotel offers accommodation with an outdoor swimming pool, free private parking, a garden and a restaurant. This 5-star hotel offers room service, a 24-hour front desk and free WiFi. The hotel features an indoor pool and free shuttle service. At the hotel every room has air conditioning, a desk, a terrace with a sea view, a private bathroom, a flat-screen TV, bed linen and towels. All rooms are equipped with a kettle, while certain rooms here will provide you with a kitchenette with a microwave. The units will provide guests with a fridge. Eastern Star Golf Course is 32 km from Worita Cove Hotel, while Emerald Golf Resort is 36 km away. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 32 km from the accommodation."),
           (11, 'Novotel Marina Sriracha' , '339 Jerm Jom Phon road Sriracha', 'chonburi','4.9','https://cf.bstatic.com/xdata/images/hotel/max1024x768/275964708.jpg?k=050cf9b165e8781768a81a04fe166a0e53f9c8853cc3c5f126fc1503d5b79213&o=&hp=1','13.163810584765216', '100.91957686678036',1,NULL, "Located in Si Racha, 12 km from Bangpra International Golf Club, Novotel Marina Sriracha provides accommodation with a fitness centre, free private parking, a garden and a shared lounge. Featuring room service, this property also provides guests with a terrace. The accommodation features a 24-hour front desk, airport transfers, a kids' club and free WiFi. Guest rooms at the hotel come with air conditioning, a seating area, a flat-screen TV with satellite channels, a safety deposit box and a private bathroom with a bidet, free toiletries and a hairdryer. Rooms are equipped with a kettle, while selected rooms are equipped with a balcony and others also offer city views. At Novotel Marina Sriracha each room is fitted with bed linen and towels. At the accommodation you will find a restaurant serving American, Cantonese and Chinese cuisine. Vegetarian, dairy-free and vegan options can also be requested. Novotel Marina Sriracha offers 4-star accommodation with a sauna and outdoor pool. Bike hire and car hire are available at this hotel and the area is popular for cycling. There is an on-site bar and guests can also make use of the business area. Crystal Bay Golf Club is 16 km from the hotel, while Flight of The Gibbon is 22 km away. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 64 km from Novotel Marina Sriracha."),
           (12, 'Sorin hotel' , '22 Thanon Thetsaban 3', 'surin','4.1','https://cf.bstatic.com/xdata/images/hotel/max1024x768/109510441.jpg?k=f81e070f894d42ed9378bb77586ce76c4670b4ddf431d6e36de6885d3d2ef2eb&o=&hp=1','14.880637480380893', '103.48345055146993',1,NULL, "Located in Surin city centre, Sorin Hotel offers a modern accommodation with sun terrace and views of the city. Free WiFi is featured throughout the property and free private parking is available on site. Every room at this hotel is air conditioned and is equipped with a flat-screen TV. Some rooms have a seating area where you can relax. You will find a kettle in the room. All rooms come with a private bathroom. For your comfort, you will find slippers and a hairdryer. Guests can enjoy the on-site restaurant Ho By. 24-hour front desk and 24-hour security is available at the property. Free use of bicycles is available at this hotel and the area is popular for cycling. The nearest airport is Buri Ram Airport, 46 km from the property."),
           (13, 'Surin Majestic Hotel' , '99 Jitbumrung Road', 'surin','4.5','https://cf.bstatic.com/xdata/images/hotel/max1024x768/152649688.jpg?k=2fe82603e66834459f94c93b989682148f238fe0cedbc6b5c07eaff84eec7dad&o=&hp=1','14.890190488408715', '103.49705860729225',1,NULL, "Surin Majestic Hotel is set in Surin and features a fitness centre and garden. Boasting a 24-hour front desk, this property also provides guests with a restaurant. The accommodation provides valet parking, and luggage storage for guests. All units in Surin Majestic Hotel are equipped with a flat-screen TV. Every room comes with a kettle and a private bathroom, while selected rooms come with a balcony. All rooms at Surin Majestic Hotel include air conditioning and a desk. A buffet breakfast is available each morning at the property. Surin Majestic Hotel offers an outdoor pool. Buriram is 44 km from the property. Buri Ram Airport is 46 km away."),
           (14, 'Thong Tarin Hotel' , '60 Sirirat Road', 'surin','4.5','https://cf.bstatic.com/xdata/images/hotel/max1024x768/68994720.jpg?k=aa38649538519b4c6f8b7561d20b59dcd3acb554fd60981b7c1f96da0a179cb3&o=&hp=1','14.886731978982073', '103.49951349379887',1,NULL, "Boasting an outdoor pool with a sun terrace, Thong Tarin Hotel offers guests with several room options. Guests have access to free WiFi throughout the property. Private parking is possible for those who drive. Delectable Thai food can be sampled at the restaurant on site. All air-conditioned rooms are equipped with a flat-screen TV and a private bathroom with free toiletries. Certain rooms come with a seating area and a working space for guests' comfort. Other activities include billiards and karaoke. Friendly staff are 24-hour available at the front desk and room service is offered daily."),
           (15, 'THE WOOD' , '9 Thetsaban Bamrung', 'surin','4.4','https://cf.bstatic.com/xdata/images/hotel/max1024x768/278956642.jpg?k=d86a99df4007d7cc7cbf13e304bc4afdc5b7b82f83809e0ed57479aeda2d890e&o=&hp=1','14.887343797839463', '103.49336464962109',1,NULL, "You're eligible for a Genius discount at THE WOOD! To save at this property, all you have to do is sign in. Located in Surin, THE WOOD offers a garden. This 3-star hotel offers a 24-hour front desk, a concierge service and free WiFi. There is free private parking and the property provides paid airport shuttle service. The hotel will provide guests with air-conditioned rooms offering a wardrobe, a kettle, a fridge, a minibar, a safety deposit box, a flat-screen TV and a private bathroom with a shower. At THE WOOD each room is equipped with bed linen and towels. The nearest airport is Buri Ram Airport, 78 km from the accommodation."),
           (16, 'Novotel Rayong Star' , '109 Sukhumvit Road', 'rayong','4.7','https://cf.bstatic.com/xdata/images/hotel/max1024x768/490713581.jpg?k=b2bbfa01c8a31f4f2d7f477cf797c0339d95cb6fbd4dde947505f8b7ea7b1b3b&o=&hp=1','12.68614612687781', '101.27111228211439',1,NULL, "Set in Rayong, 25 km from Emerald Golf Resort, Novotel Rayong Star Convention Centre offers accommodation with an outdoor swimming pool, free private parking, a fitness centre and a restaurant. This 4-star hotel offers room service and babysitting service. The accommodation provides a 24-hour front desk, airport transfers, a kids' club and free WiFi throughout the property. All guest rooms at the hotel come with a flat-screen TV with satellite channels and a safety deposit box. The rooms come with a private bathroom fitted with a bidet and free toiletries, while selected rooms also feature a kitchenette equipped with a microwave. All units will provide guests with a fridge. Breakfast is available every morning, and includes buffet, American and Asian options. Novotel Rayong Star Convention Centre offers a children's playground. Eastern Star Golf Course is 32 km from the accommodation, while Khao Laem Ya National Park is 23 km from the property. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 35 km from Novotel Rayong Star Convention Centre."),
           (17, 'The Feeling Hotel' , '148/1 Rajbamrung Road,', 'rayong','4.9','https://cf.bstatic.com/xdata/images/hotel/max1024x768/201964724.jpg?k=6fa0fc1763677b25db0213688a6874ec448ddba6ad56560130b2e78193953439&o=&hp=1','12.681017397451605', '101.25741916677212',1,NULL, "Located in Rayong, 24 km from Emerald Golf Resort, The Feeling Hotel provides accommodation with a shared lounge, free private parking, a terrace and a restaurant. The property is around 30 km from Eastern Star Golf Course, 24 km from Khao Laem Ya National Park and 39 km from Rayong Botanical Garden. Each room has a balcony with city views and free WiFi. Guest rooms at the hotel come with air conditioning, a seating area, a flat-screen TV with satellite channels, a kitchen, a dining area and a private bathroom with free toiletries, a shower and a hairdryer. All units will provide guests with a fridge. Speaking English and Thai at the reception, staff are ready to help around the clock. Bira International Circuit Pattaya is 40 km from The Feeling Hotel, while RamaYana Water Park is 42 km away. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 33 km from the accommodation."),
           (18, 'Holiday Inn Rayong' , '554/4 Sukhumvit Road', 'rayong','4.8','https://cf.bstatic.com/xdata/images/hotel/max1024x768/515417547.jpg?k=83102aab071771c1d67ba8fd75d65f1506e8daca9f0237366136b54cee972f5b&o=&hp=1','12.683676129215955', '101.24995180725197',1,NULL, "Set in Rayong, 100 metres from Passione Shopping Destination, Holiday Inn Hotel & Suites Rayong City Centre is set in Rayong. Boasting a rooftop pool and bar as well as a fitness centre, this hotel offer an accommodation with free WiFi and free parking. Every room at this hotel is air conditioned and has a TV. Some rooms include a seating area for your convenience. You will find a kettle in the room. Every room has a private bathroom. For your comfort, you will find bathrobes, slippers and free toiletries. There is a 24-hour front desk at the property. Asian and international cuisines  are served at The Brasserie, while selection of cocktails, wines and beers accompanied by live music can be enjoyed at CU Lounge & Bar. Phra Samut Chedi Klang Nam is 2.1 km from the property, while Ko Kloy Floating Market is 2.3 km away. Utapao-Rayong-Pataya International Airport is 27 km away."),
           (19, 'Hotel Fuse Rayong' , '188/88 Moo 2, T.Thapma', 'rayong','4.3','https://cf.bstatic.com/xdata/images/hotel/max1024x768/242466516.jpg?k=8f2eee0a58c56a6dd4a429dea77a33a67dfc00ca02a27aa6bb9191edc3b2baf5&o=&hp=1','12.69834148247118', '101.21560376677232',1,NULL, "Set in Rayong, 20 km from Emerald Golf Resort, Hotel Fuse Rayong offers accommodation with a shared lounge, free private parking, a restaurant and a bar. This 4-star hotel offers room service, a 24-hour front desk and free WiFi. The property is allergy-free and is situated 26 km from Eastern Star Golf Course. Khao Laem Ya National Park is 30 km from the hotel, while Bira International Circuit Pattaya is 38 km from the property. The nearest airport is U-Tapao Rayong-Pattaya International Airport, 29 km from Hotel Fuse Rayong."),
           (20, 'Phavina Hotel Rayong' , '28/26 Moo3 Nernpra Muang', 'rayong','4.2','https://cf.bstatic.com/xdata/images/hotel/max1024x768/276284420.jpg?k=64ababeb01a81350017e42a8da002d3fa842e7aca83ed0c93d50d0499c6fc69e&o=&hp=1','12.684626929364756', '101.22393220684712',1,NULL, "Located 4 km from Rayong city centre, Phavina Service Residence offers free Wi-Fi throughout the property. Featuring a garden, the hotel also provides free public parking on site. The hotel is 1.5 km to Rayong sport stadium.  Saeng-Chan Beach is 3.5 km away. It is 26 km from Baan Phe Pier to Samet Island. Fitted with a balcony, each air-conditioned room features a flat-screen cable TV, fridge and wardrobe. Shower facilities and hairdryer are included in an en suite bathroom. Selected rooms come with a safe, seating area and kitchen. For extra convenience, there is a 24-hour front desk. Laundry services and fitness centre are available. Phavina Cafe serves a variety of Thai cuisine.")
  ''');
      await db.rawInsert('''
    INSERT INTO Rooms (room_id, room_number, type, price, hotel_id , room_img , adult , child , room_description)
    VALUES (101, '101', 'Deluxe Double Room', 79.00, 1 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/261439054.jpg?k=1f9b255ad8f887511f4a92b934623f83d3af0ecb904a4559330119a632934eaa&o=&hp=1' , 2 , 1 , "Room size 27 m² Comfy beds, This air-conditioned room features a flat-screen TV and a sofa."),
           (102, '102', 'Superior Twin Room', 89.00, 1 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/261215188.jpg?k=edafdfa154c9624f8c4d6ae583088f408592d1e08acb7bc5590d5573e6bb1ed3&o=', 2 , 1 , "Room size 23 m² Comfy beds, This superior twin room features a seating area, air conditioning and cable TV."),
           (201, '201', 'Studio Executive Double', 20.00, 2 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/533686414.jpg?k=d580fa3e11b1aac2b269a93dd1f4c3e5991ad42d09364b67a51182f65305a0db&o=' , 2 , 1 , "Room size 22 m² Comfy beds, Studio features a flat-screen cable TV, a work station and an en suite bathroom."),
           (202, '202', 'Premier Double Room', 50.00, 2 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/533686792.jpg?k=92141bc42e642c01287c1af85c0e3af648770687ec31b4c2ebc163e5496d4345&o=' , 2 , 1 , "Room size 30 m² Comfy beds, Largest air-conditioned room features a refrigerator, coffee/tea making facilities and a safety deposit box. A hairdryer and free toiletries are included in an en suite bathroom."),
           (302, '302', 'Value Double', 60.00, 3 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/67077666.jpg?k=f59f5f9048cff391c2bf3f207e1758e39b69e288686e0edea76ec40dd0ee428a&o=' , 2 , 1 , "Size 12 m² Comfy beds, This double room features a fridge, a cable flat-screen TV and free WiFi. The en suite bathroom comes with a hot shower. Free early check in and late check out is offered."),
           (401, '401', 'Standard Double Room', 79.00, 4 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/22661519.jpg?k=73c91ac84c11e3b0212690054747b527058f3ba1fa24758f31655fb1398fef4c&o=' , 2 , 1 ,"Room size 22 m² Comfy beds, Air-conditioned room features a flat-screen cable TV, a fridge and an en suite bathroom with shower facilities."),
           (402, '402', 'Standard Twin Room', 79.00, 4 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/22664836.jpg?k=2ce08e6313afa3a5cff6f1bb959089265e7f9b273d8131ecee56cde8b94c85a4&o=' , 2 , 1 ,"Room size 22 m² Comfy beds, Air-conditioned room features a flat-screen cable TV, a fridge and an en suite bathroom with shower facilities."),
           (501, '501', 'Deluxe King Room', 99.00, 5 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/218619741.jpg?k=38534824a907df7b7f2d440ac2413ed7f2d5cacdd3496d2359819dd591212e43&o=' , 2 , 1 ,"Room size 25 m² Comfy beds, This air-conditioned double room is comprised of a flat-screen TV with cable channels, a private bathroom as well as a balcony. The unit has 1 bed."),
           (601, '601', 'Deluxe Double Room', 99.00, 6 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/384954616.jpg?k=c5eef2ba2edc1eedee7e002ae3dd486ba510fd8b1dc4886d3066377c9399158d&o=' , 2 , 1 ,"Room size 35 m² Comfy beds, The spacious double room features air conditioning, a tea and coffee maker, a balcony with pool views as well as a private bathroom boasting a shower. The unit has 1 bed."),
           (602, '602', 'Deluxe Twin Room', 99.00, 6 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/242575736.jpg?k=d7effeab36deb879e6cae86bda1d50a3529b8ce9e24f9d4359833409d40e4b53&o=' , 2 , 1 ,"Room size 35 m² Comfy beds, The spacious twin room offers air conditioning, a tea and coffee maker, a balcony with pool views as well as a private bathroom featuring a shower. The unit offers 2 beds."),
           (603, '603', 'Executive Suite', 99.00, 6 , 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/234008288.jpg?k=d0b3c8c8c728b09c77d8ae15ff771c7a437c33ad74c5c6382b0cd487c2c50479&o=' , 2 , 1 ,"Room size 35 m² Comfy beds, The air-conditioned suite has 1 bedroom and 1 bathroom with a shower and a bidet. Boasting a balcony with pool views, this suite also offers a tea and coffee maker and a flat-screen TV with cable channels. The unit has 1 bed."),
           (701, '701','Deluxe Room', 69.00 , 7 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/414515272.jpg?k=22302a6fc6800ef52c1035d13f5c685c0dd1f20f32c65682470ca781b40f3e11&o=' , 2 , 1 , "Room size 25 m² Comfy beds, The double room features air conditioning, an electric kettle, a terrace with garden views as well as a private bathroom boasting a shower. The unit has 1 bed."),
           (702, '702','Deluxe Twin Room', 69.00 , 7 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/409718559.jpg?k=51f423672185e18266ffab50c54d6a0ce49df6101b8b8db26833bcbe043db4ee&o=' , 2 , 1 , "Room size 25 m² Comfy beds, The twin room offers air conditioning, an electric kettle, a terrace with garden views as well as a private bathroom featuring a shower. The unit offers 2 beds."),
           (801, '801','Junior Suite', 79.00 , 8 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/463556032.jpg?k=9c17bb2b00470442284eec98ae23f6b5550a8b70b15525b6015e9f2d7639ff33&o=' , 2 , 1 , "Room size 62 m² Comfy beds, The rooftop pool is the standout feature of this suite. This spacious suite comes with 1 living room, 1 separate bedroom and 1 bathroom with a shower and free toiletries. This air-conditioned suite includes a dining area, a flat-screen TV with cable channels a private entrance and a terrace. The unit has 1 bed."),
           (802, '802','One-Bedroom Suite', 89.00 , 8 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/463556422.jpg?k=2cf053e1dd5a1d6ddd3d8eee9c8a542470c9444da49f527568d7d9f02c15e04f&o=' , 2 , 1 , "Room size 72 m² Comfy beds,  The rooftop pool and hot tub are the special features of this suite. This spacious suite is comprised of 1 living room, 1 separate bedroom and 1 bathroom with a bath and free toiletries. This air-conditioned suite comes with a dining area, a flat-screen TV with cable channels a private entrance and a terrace. The unit offers 1 bed."),
           (901, '901','Superior King Room', 99.00 , 9 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/413155047.jpg?k=97d479d1501b9f69033a0772e76eb6fa89d70f6267637b1f249175199a55d32b&o=' , 2 , 1 , "Room size 32 m² Comfy beds, The spacious double room provides air conditioning, soundproof walls, a terrace with garden views as well as a private bathroom featuring a shower. The unit offers 1 bed."),
           (902, '902','Superior Corner Room', 109.00 , 9 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/466928084.jpg?k=7becbb0e840a51768b2134ada606a67be3513de1f1263a5c7e69fbdc77559c27&o=' , 2 , 1 , "Room size 42 m² Comfy beds, The air-conditioned suite features 1 bedroom and 1 bathroom with a shower and a hairdryer. Featuring a terrace with garden views, this suite also provides soundproof walls and a flat-screen TV. The unit offers 1 bed."),
           (903, '903','Resort Room', 59.00 , 9 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/413158126.jpg?k=55705b28408cb723270612454de75e1ccd0d2f6ed510ac0d5be8f38ce8751762&o=' , 2 , 1 , "Room size 32 m² Comfy beds, The air-conditioned suite has 1 bedroom and 1 bathroom with a shower and a hairdryer. Boasting a terrace with garden views, this suite also offers soundproof walls and a flat-screen TV. The unit has 1 bed."),
           (1001, '1001','Superior Twin Room', 99.00 , 10 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/159983445.jpg?k=896a940111cbfdf39f1f3c4145298e27cf0eeb18b6ad9a594e39ad2e2d582b8c&o=' , 2 , 1 , "Room size 30 m² Comfy beds, Guests will have a special experience as this twin room provides a pool with a view. The twin room offers air conditioning, a private entrance, a terrace with sea views as well as a private bathroom featuring a shower. The unit offers 2 beds."),
           (1002, '1002','Deluxe Seaview', 49.00 , 10 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/159982229.jpg?k=7c1b2549f0b2356ebfffd7f34a601bebff511a06b7793fda88bed9e15777dbca&o=' , 2 , 1 , "Room size 34 m² Comfy beds, Guests will have a special experience as this double room features a pool with a view. The spacious double room offers air conditioning, a private entrance, a terrace with sea views as well as a private bathroom featuring a shower. The unit offers 1 bed."),
           (1101, '701','Superior room', 69.00 , 11 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/275961856.jpg?k=00db13bfa1e7644d5b5ce4fb799531abd2bdf581b8ac8ba2267e63ff7eb14161&o=' , 2 , 1 , "Room size 28 m² Comfy beds, Offering free toiletries, this double room includes a private bathroom with a walk-in shower, a bidet and a hairdryer. The spacious air-conditioned double room offers a flat-screen TV with streaming services, soundproof walls, a minibar, a tea and coffee maker as well as mountain views. The unit has 1 bed."),
           (1102, '1102','Deluxe Room', 89.00 , 11 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/275962057.jpg?k=b751bdcd789c2e8c1dccf26ed18a6960137ac0b2d2af1de0077ba459638d06b5&o=' , 2 , 1 , "Room size 32 m² Comfy beds, Featuring free toiletries and bathrobes, this twin room includes a private bathroom with a walk-in shower, a bidet and a hairdryer. The spacious air-conditioned twin room features a flat-screen TV with streaming services, soundproof walls, a minibar, a tea and coffee maker as well as sea views. The unit has 2 beds."),
           (1201, '1201','Deluxe Room', 79.00 , 12 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/109262026.jpg?k=5588d920fc974470e8844676805e5ee0d094630d24221412eceb5933bbb5e8db&o=' , 2 , 1 , "Room size 30 m² Comfy beds, The spacious double room features air conditioning, a minibar, a balcony with city views as well as a private bathroom boasting a shower. The unit has 1 bed."),
           (1202, '1202','Suite', 69.00 , 12 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/510555154.jpg?k=a97df3de9da527d3deb8713c922ad920beea283404d1f0aa36cc676fa17b20e5&o=' , 2 , 1 , "Room size 52 m² Comfy beds, This spacious suite features 1 living room, 1 separate bedroom and 1 bathroom with a bath and free toiletries. This air-conditioned suite consists of a dining area, a flat-screen TV with cable channels a minibar and a terrace. The unit has 2 beds."),
           (1301, '1301','Deluxe King Room', 59.00 , 13 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/152647549.jpg?k=7948ca86aa452337d64e95a89524897b48ccbfeba1eb850d347568ba7d944e03&o=' , 2 , 1 , "Room size 25 m² Comfy beds, This double room features a pool with a view. This air-conditioned double room is comprised of a flat-screen TV with cable channels, a private bathroom as well as a terrace with pool views. The unit has 1 bed."),
           (1302, '1302','Deluxe Twin Room', 69.00 , 13 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/152647571.jpg?k=5c07a19ac134a70cd7abfc1f6ab37a3697bdb8ad4625d6da167ca96b0bed0fd5&o=' , 2 , 1 , "Room size 25 m² Comfy beds, Guests will have a special experience as this twin room offers a pool with a view. This air-conditioned twin room includes a flat-screen TV with cable channels, a private bathroom as well as a terrace with pool views. The unit offers 2 beds."),
           (1401, '1401','Deluxe Double Room', 129.00 , 14 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/354005204.jpg?k=f1e2d0f84356bb87d8048ac682fb32f33bf942d571f2dca49482c8bbdbbdbfbd&o=' , 2 , 1 , "Room size 25 m² Comfy beds, Offering free toiletries, this double room includes a private bathroom with a shower. The spacious double room offers air conditioning, a dining area, a wardrobe, an electric kettle, as well as a flat-screen TV with cable channels. The unit has 1 bed."),
           (1402, '1402','Executive Suite', 159.00 , 14 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/479297460.jpg?k=12238deb44657579dd58b5c33642f9851b0f7df7b8a2db429bba6e0f7a59509e&o=' , 2 , 1 , "Room size 58 m² Comfy beds, This spacious suite is comprised of 1 living room, 1 separate bedroom and 1 bathroom with a bath and free toiletries. The well-fitted kitchenette has a refrigerator, a microwave and an electric kettle. This suite features air conditioning, a minibar, flat-screen TV with cable channels, as well as fruit for guests. The unit offers 2 beds."),
           (1403, '1403','VIP Suite', 119.00 , 14 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/452930271.jpg?k=88ffaf1c9e69278b12751b02b34b5fb5c471f18ec8809f363b3f4880add517a6&o=' , 2 , 1 , "Room size 51 m² Comfy beds, This spacious suite comes with 1 living room, 1 separate bedroom and 1 bathroom with a bath and free toiletries. Guests can make meals in the kitchenette that features a refrigerator, a microwave and an electric kettle. This suite has air conditioning, a minibar, flat-screen TV with cable channels, as well as fruit for guests. The unit has 2 beds."),
           (1501, '1501','Superior Double Room', 119.00 , 15 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/268144365.jpg?k=d05aeb0f48f64e108fca73c35f0c16abb98f38532dc9d82bc3d798979fd96cd5&o=' , 2 , 1 , "Room size 38 m² Comfy beds, This double room has a minibar, air conditioning and tea/coffee maker. Please note that this room is only accessible by stairs."),
           (1502, '1502','Large Double Room', 119.00 , 15 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/277040578.jpg?k=6bafb4007f4080279e3d19fccdeb4670ecbbae32077e85a8ca21c670f60044ab&o=' , 2 , 1 , "Room size 38 m² Comfy beds, The double room includes a private bathroom fitted with a shower, a hairdryer and slippers. The spacious air-conditioned double room offers a flat-screen TV with streaming services, a minibar, a tea and coffee maker, a wardrobe as well as garden views. The unit has 1 bed."),
           (1601, '1601','Superior Twin Room', 49.00 , 16 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/451820031.jpg?k=c442ea4a5c7ef7519413b83716c5f07e4e2f4691ec0fb126e09c94ae0a34905a&o=' , 2 , 1 , "Room size 32 m² Comfy beds, Offering free toiletries and bathrobes, this double room includes a private bathroom with a shower, a bidet and a hairdryer. Meals can be prepared in the well-fitted kitchenette, which is fitted with a refrigerator, kitchenware and a microwave. The spacious air-conditioned double room offers a flat-screen TV with satellite channels, soundproof walls, a minibar, a safe deposit box as well as city views. The unit offers 2 beds."),
           (1602, '1602','Standard King Room', 89.00 , 16 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/451820034.jpg?k=613709c2cfbd20122f191bf80465c282bbe3a5b49d3436640844f5a0bf289314&o=' , 2 , 1 , "Room size 29 m² Comfy beds, Featuring free toiletries and bathrobes, this double room includes a private bathroom with a shower, a bidet and a hairdryer. The spacious air-conditioned double room features a flat-screen TV with satellite channels, soundproof walls, a safe deposit box, a sofa as well as city views. The unit has 1 bed."),
           (1701, '1701','Double Room with Balcony', 79.00 , 17 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/201965090.jpg?k=6c99ea278d91454fcd8642249f100d225c6f6ba83067c874dd190734a02c239a&o=' , 2 , 1 , "Room size 30 m² Comfy beds, Guests can make meals in the kitchen that features a refrigerator, a microwave and a tea and coffee maker. The spacious double room features air conditioning, soundproof walls, a terrace with city views as well as a private bathroom boasting a shower. The unit has 1 bed."),
           (1702, '1702','Twin Room', 99.00 , 17 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/201964444.jpg?k=2b6357095ec0d755a5901b9444f6cc46d8d043c1c7fda73510c8eef90b44e373&o=' , 2 , 1 , "Room size 30 m² Comfy beds, The fully equipped kitchen features a refrigerator, a microwave and a tea and coffee maker. This air-conditioned twin room includes a flat-screen TV with cable channels, a private bathroom as well as a terrace with city views. The unit offers 2 beds."),
           (1801, '1802','1 King Bed 1 Bedroom Suite', 79.00 , 18 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/502775635.jpg?k=99e26077710657dc100e94f445465525470427ffb4ecba4b47109ef899e3e682&o=' , 2 , 1 , "Room size 65 m² Comfy beds, The hot tub is the standout feature of this suite. This spacious suite features 1 bedroom, a seating area and 1 bathroom with a bath and a shower. The air-conditioned suite features a flat-screen TV with streaming services, soundproof walls, a minibar, a tea and coffee maker as well as sea views. The unit has 1 bed."),
           (1802, '1802','Premium Room Sea View', 79.00 , 18 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/132277426.jpg?k=70dee094293a6caa62e3da9b482187d8f2d3151ca1dc312a12e0b37152ab18f4&o=' , 2 , 1 , "Room size 32 m² Comfy beds, Providing free toiletries, this triple room includes a private bathroom with a shower, a bidet and a hairdryer. The spacious air-conditioned triple room provides a flat-screen TV with streaming services, soundproof walls, a tea and coffee maker, a wardrobe as well as sea views. The unit offers 3 beds."),
           (1901, '1901','Junior Suite', 69.00 , 19 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/275363606.jpg?k=184a35d925a82e31f72d1bd1ef4ad5b249a72f92e0ec70465494614c481f6d5e&o=' , 2 , 1 , "Room size 41 m² Comfy beds, The air-conditioned suite features 1 bedroom and 1 bathroom with a walk-in shower and a bidet. The suite provides a seating area, a dining area, a safe deposit box, a flat-screen TV with cable channels, as well as city views. The unit offers 1 bed."),
           (2001, '2001','Standard Double Room', 49.00 , 20 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/480514765.jpg?k=12080532f3fb7f86ca2523f7c113af6b7ad23f6b12947a1491c235b80aefffec&o=' , 2 , 1 , "Room size 30 m² Comfy beds, Fitted with a balcony, air-conditioned room features a flat-screen cable TV, fridge and wardrobe. Shower facilities and hairdryer are included in an en suite bathroom."),
           (2002, '2002','Deluxe Double Room', 49.00 , 20 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/480514723.jpg?k=6aa0f58194802dc9d25d5aa11994c312e7f09ec5b3aabd993a8dfb611be4d206&o=' , 2 , 1 , "Room size 45 m² Comfy beds, Fitted with a balcony, larger air-conditioned room features a flat-screen cable TV, fridge and wardrobe. Shower facilities and hairdryer are included in an en suite bathroom. It comes with a safe, seating area and kitchen."),
           (2003, '2003','Standard Twin Room', 49.00 , 20 ,'https://cf.bstatic.com/xdata/images/hotel/max1024x768/480514774.jpg?k=632857cee29f6e46f4d278a8e03501bd200d14416e4344b53c41dc02e14d9a8f&o=' , 2 , 1 , "Room size 30 m² Comfy beds, This air-conditioned twin room is comprised of a flat-screen TV with cable channels, a private bathroom as well as a terrace. The unit has 2 beds.")
  ''');
      await db.rawInsert('''
    INSERT INTO Bookings (booking_id, room_id, userId, checkin_date, checkout_date ,first_name , last_name ,email , phone_number)
=======
            checkOutDate DATE
            )
            ''');
      print(
          'wowowowowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwooooooooooooooooooooooooooo');
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
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
    VALUES (1, 101, 1001, '2024-02-01', '2024-02-03', 'perapon' , 'kaewtaweesap' , 'perapon.ka@ku.th' , '0646097891'),
           (2, 201, 1002, '2024-02-05', '2024-02-08',' chick', 'ken' , 'kfckfc@kfc.com' ,'012345678'),
           (3, 301, 1002, '2024-02-10', '2024-02-12','mobile' ,'app' ,'abc@abc.com' ,'0132154')
  ''');
<<<<<<< HEAD

      await db.rawInsert('''
    INSERT INTO Users (userId, userName, userEmail, userPass, address, role)
    VALUES (1001, 'John Does', 'john@example.com','123456','Ku sriracha' , 1),
           (1002, 'Test', 'test@test.com','123456', 'Ku sriracha' , 1),
           (1003, 'Alice', 'admin@test.com','123456', 'Ku sriracha' , 2)
  ''');
      await db.rawInsert('''
      INSERT INTO Roles (RoleId, RoleName) 
      VALUES (1,'Customer'),
      (2,'Hotel')
    ''');
      await db.rawInsert('''
=======
      await db.rawInsert('''
    INSERT INTO Users (user_id, name, email)
    VALUES (1001, 'John', 'john@example.com'),
           (1002, 'Alice', 'alice@example.com')
  ''');
      await db.rawInsert('''
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
    INSERT INTO Facilities (facilities_id, facilities_name) 
    VALUES (1, 'ห้องน้ำ'),
            (2, 'แอร์'),
            (3, 'WiFi'),
            (4, 'ทีวี'),
            (5, 'ฟิตเนส')
  ''');
      await db.rawInsert('''
    INSERT INTO HotelFacilities (hotel_id, facilities_id)
<<<<<<< HEAD
    VALUES (1, 1),(1, 2),(1, 3),(1, 4),(1, 5),
          (2, 1),(2, 2),(2, 3),
          (3, 1),(3, 2),(3, 3),(3, 4),
          (4, 1),(4, 2),(4, 3),(4, 4),(4, 5),
          (5, 1),(5, 2),(5, 3),(5, 4),
          (6, 1),(6, 2),(6, 3),
          (7, 1),(7, 2),(7, 3),
          (8, 1),(8, 2),(8, 3),
          (9, 1),(9, 2),(9, 3),(9, 4),(9, 5),
          (10, 1),(10, 2),(10, 3),(10, 4),
          (11, 1),(11, 2),(11, 3),
          (12, 1),(12, 2),(12, 3),(12, 4),(12, 5),
          (13, 1),(13, 2),(13, 3),(13, 4),
          (14, 1),(14, 2),(14, 3),(14, 5),
          (15, 1),(15, 2),(15, 3),(15, 4),
          (16, 1),(16, 2),(16, 3),
          (17, 1),(17, 2),(17, 3),(17, 4),
          (18, 1),(18, 2),(18, 3),(18, 4),(18, 5),
          (19, 1),(19, 2),(19, 3),(19, 4),
          (20, 1),(20, 2),(20, 3),(20, 4),(20, 5)
  ''');
      await db.rawInsert('''
      INSERT INTO FavoriteHotel (userId,hotel_id)
      VALUES (1001, 4),
            (1002, 5)
    ''');
=======
    VALUES (1, 1),
          (1, 2),
          (2, 1),
          (3, 3),
          (4, 1),
          (4, 2),
          (5, 1)
  ''');
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
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
        lat: result[index]['lat'],
        long: result[index]['long'],
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
        lat: result[index]['lat'],
        long: result[index]['long'],
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
      '''SELECT h.hotel_id , h.name , h.address , h.city , h.img , MIN(r.price) as lowest , h.hotel_description ,h.lat ,h.long, h.ratings 
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

  Future<void> InsertBookingDetail(
      BookingDetailModel bookingDetailModel) async {
    var db = await initializedb();
    await db.insert('bookingdetail', bookingDetailModel.toMap());
  }

<<<<<<< HEAD
  Future<List<BookingDetailModel>> getBookingDetail(int userId) async {
    var db = await initializedb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT BookingDetail.*, Hotels.name, Hotels.img
    FROM BookingDetail
    JOIN Hotels ON BookingDetail.hotelId = Hotels.hotel_id
    WHERE userId = ?
  ''', [userId]);
=======
  Future<List<BookingDetailModel>> getBookingDetail() async {
    var db = await initializedb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT * FROM BookingDetail
  ''');
>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc
    // แปลง List<Map<String, dynamic>> เป็น List<Hotel>
    return List.generate(maps.length, (i) {
      return BookingDetailModel.fromMap(maps[i]);
    });
  }
<<<<<<< HEAD

  Future<List<HotelModel>> getFavoriteHotel(int userId) async {
    var db = await initializedb();
    List<Map<String, dynamic>> result =
        // await db.query('hotels', where: 'id=?', whereArgs: [itemId]);
        await db.rawQuery(
      '''
          SELECT Hotels.*
          FROM Hotels 
          JOIN FavoriteHotel ON Hotels.hotel_id = FavoriteHotel.hotel_id
          WHERE FavoriteHotel.userId = ?
          ''',
      [userId],
    );
    return List.generate(
      result.length,
      (index) => HotelModel(
        id: result[index]['id'],
        name: result[index]['name'],
        address: result[index]['address'],
        city: result[index]['city'],
        img: result[index]['img'],
        ratings: result[index]['ratings'],
      ),
    );
  }

  Future<List<UsersModel>> queryUser(UsersModel user) async {
    var db = await initializedb();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT userId, userName, userEmail, userPass, role FROM Users 
    WHERE userEmail ='${user.usrEmail}' AND userPass = '${user.usrPassword}'
  ''');
    print("Login result $result");
    // ดำเนินการอื่น ๆ ที่ต้องการในกรณีที่มีข้อมูลผลลัพธ์
    return List.generate(result.length, (i) {
      return UsersModel.fromMap(result[i]);
    });
  }

  Future checkFavorite(int userId, int hotelId) async {
    var db = await initializedb();
    final result = await db.query(
      'FavoriteHotel',
      where: 'userId = ? AND hotel_id = ?',
      whereArgs: [userId, hotelId],
    );
    return result.isNotEmpty;
  }

  Future<void> addFavHotels(FavoriteHotel favModel) async {
    var db = await initializedb();
    var result = await db.insert(
      'FavoriteHotel',
      favModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("add fav => : $result");
  }

  Future removeFavHotels(FavoriteHotel favModel) async {
    var db = await initializedb();
    var result = db.delete(
      'FavoriteHotel',
      where: 'userId = ? AND hotel_id = ?',
      whereArgs: [favModel.userId, favModel.hotelId],
    );
    print("remove fav => : $result");
    return result;
  }

  Future<UsersModel?> getUser(int userId) async {
    var db = await initializedb();
    final result = await db.query(
      'Users',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return UsersModel.fromMap(result.first);
    } else {
      return null;
    }
  }

// ฟังก์ชันสำหรับแก้ไขข้อมูลของผู้ใช้
  Future updateUser(UsersModel user) async {
    var db = await initializedb();
    print('Updating user: ${user.address.toString()}');
    await db.update(
      'Users',
      user.toMap(),
      where: 'userId = ?',
      whereArgs: [user.usrId],
    );
  }
}
=======
}


>>>>>>> 40d05ae19bb53479ca4d28c736cf1a1dded2bcdc

// class HotelModel {
//   final int? id;
//   final String name;
//   final String address;
//   final String city;
//   final String img;
//   final int? countFacility;
//   final double? lowest;
//   final String hotelDescription;
//   final double ratings;
//   final String lat;
//   final String long;
//   HotelModel(
//       {this.id,
//       required this.name,
//       required this.address,
//       required this.city,
//       required this.img,
//       this.countFacility,
//       required this.lowest,
//       required this.hotelDescription,
//       required this.ratings,
//       required this.lat,
//       required this.long});
//   HotelModel.fromMap(Map<String, dynamic> item)
//       : id = item['id'],
//         name = item['name'],
//         address = item['address'],
//         city = item['city'],
//         img = item['img'],
//         countFacility = item['facility_count'],
//         lowest = item['lowest'],
//         hotelDescription = item['hotel_description'],
//         ratings = item['ratings'],
//         lat = item['lat'],
//         long = item['long'];

//   Map<String, Object?> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'address': address,
//       'city': city,
//       'img': img,
//       'facility_count': countFacility,
//       'lat': lat,
//       'long': long,
//     };
//   }
// }

class getHotelModel {
  final int id;
  final String? name;
  final String? address;
  final String? city;
  final String? hotelDescription;

  getHotelModel({
    required this.id,
    this.name,
    this.address,
    this.city,
    this.hotelDescription,
  });
  getHotelModel.fromMap(Map<String, dynamic> item)
      : id = item['hotel_id'],
        name = item['name'],
        address = item['address'],
        city = item['city'],
        hotelDescription = item['hotel_description'];

  Map<String, Object?> toMap() {
    return {
      'hotel_id': id,
      'name': name,
      'address': address,
      'city': city,
      'hotel_description': hotelDescription
    };
  }
}

class RoomModelForHotel {
  final int? roomId;
  final String? roomNumber;
  final String? type;
  final double? price;
  final int? hotelId;
  final String? roomImg;
  final String? adult;
  final String? child;
  final String? roomDescription;

  RoomModelForHotel({
    this.roomId,
    this.roomNumber,
    this.type,
    this.price,
    this.hotelId,
    this.roomImg,
    this.adult,
    this.child,
    this.roomDescription,
  });

  RoomModelForHotel.fromMap(Map<String, dynamic> item)
      : roomId = item['room_id'],
        roomNumber = item['room_number'],
        type = item['type'],
        price = item['price'],
        hotelId = item['hotel_id'],
        roomImg = item['room_img'],
        adult = item['adult'],
        child = item['child'],
        roomDescription = item['room_description'];

  Map<String, Object?> toMap() {
    return {
      'room_id': roomId,
      'room_number': roomNumber,
      'type': type,
      'price': price,
      'hotel_id': hotelId,
      'room_img': roomImg,
      'adult': adult,
      'child': child,
      'room_description': roomDescription,
    };
  }
}

class BookingModel {
  final int? booking_id;
  final int? user_id;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? phone_number;
  final String? statusName;
  final String? checkin_date;
  final String? checkout_date;
  final String? room_number;
  final String? typeName;
  final int? status;
  BookingModel(
      {this.booking_id,
      this.user_id,
      this.first_name,
      this.last_name,
      this.email,
      this.phone_number,
      this.statusName,
      this.checkin_date,
      this.checkout_date,
      this.room_number,
      this.typeName,
      this.status});

  BookingModel.fromMap(Map<String, dynamic> item)
      : booking_id = item['booking_id'],
        user_id = item['user_id'],
        first_name = item['first_name'],
        last_name = item['last_name'],
        email = item['email'],
        phone_number = item['phone_number'],
        statusName = item['statusName'],
        checkin_date = item['checkin_date'],
        checkout_date = item['checkout_date'],
        room_number = item['room_number'],
        status = item['status'],
        typeName = item['type'];

  Map<String, dynamic> toMap() {
    return {
      'booking_id': booking_id,
      'user_id': user_id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone_number': phone_number,
      'statusName': statusName,
      'checkin_date': checkin_date,
      'checkout_date': checkout_date,
      'room_number': room_number,
      'type': typeName,
      'status': status
    };
  }
}

class BookingCancelModel {
  final int? booking_id;
  final String first_name;
  final String last_name;
  final String email;
  final String phone_number;
  final String statusName;
  final String checkin_date;
  final String checkout_date;
  final String room_number;
  final String typeName;
  final int status;
  BookingCancelModel(
      {this.booking_id,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.phone_number,
      required this.statusName,
      required this.checkin_date,
      required this.checkout_date,
      required this.room_number,
      required this.typeName,
      required this.status});

  BookingCancelModel.fromMap(Map<String, dynamic> item)
      : booking_id = item['booking_id'],
        first_name = item['first_name'],
        last_name = item['last_name'],
        email = item['email'],
        phone_number = item['phone_number'],
        statusName = item['statusName'],
        checkin_date = item['checkin_date'],
        checkout_date = item['checkout_date'],
        room_number = item['room_number'],
        status = item['status'],
        typeName = item['type'];

  Map<String, dynamic> toMap() {
    return {
      'booking_id': booking_id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone_number': phone_number,
      'statusName': statusName,
      'checkin_date': checkin_date,
      'checkout_date': checkout_date,
      'room_number': room_number,
      'type': typeName,
      'status': status
    };
  }
}

// class UsersModel {
//   final int? usrId;
//   final String usrName;
//   final String usrPassword;
//   final int? role;

//   UsersModel(
//       {this.usrId,
//       required this.usrName,
//       required this.usrPassword,
//       this.role});

//   UsersModel.fromMap(Map<String, dynamic> item)
//       : usrId = item["userId"],
//         usrName = item["userName"],
//         usrPassword = item["userPass"],
//         role = item['role'];

//   Map<String, dynamic> toMap() => {
//         "userId": usrId,
//         "userName": usrName,
//         "userPass": usrPassword,
//         "role": role
//       };
// }

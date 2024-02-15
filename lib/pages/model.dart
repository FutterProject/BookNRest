class HotelModel {
  final int? id;
  final String name;
  final String address;
  final String city;
  final String img;
  final int? countFacility;
  HotelModel({
    this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.img,
    this.countFacility,
  });
  HotelModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        address = item['address'],
        city = item['city'],
        img = item['img'],
        countFacility = item['facility_count'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'img': img,
      'facility_count': countFacility
    };
  }
}

class RoomModel {
  final int? roomId;
  final String roomNumber;
  final String type;
  final double price;
  final int hotelId;

  RoomModel({
    this.roomId,
    required this.roomNumber,
    required this.type,
    required this.price,
    required this.hotelId,
  });

  RoomModel.fromMap(Map<String, dynamic> item)
      : roomId = item['room_id'],
        roomNumber = item['room_number'],
        type = item['type'],
        price = item['price'],
        hotelId = item['hotel_id'];

  Map<String, Object?> toMap() {
    return {
      'room_id': roomId,
      'room_number': roomNumber,
      'type': type,
      'price': price,
      'hotel_id': hotelId,
    };
  }
}

class RoomAvalibleModel {
  final int? id;
  final String name;
  final String address;
  final String city;
  final String img;
  final int? roomId;
  final String roomNumber;
  final String type;
  final double price;
  final int hotelId;
  RoomAvalibleModel({
    this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.img,
    this.roomId,
    required this.roomNumber,
    required this.type,
    required this.price,
    required this.hotelId,
  });
  RoomAvalibleModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        address = item['address'],
        city = item['city'],
        img = item['img'],
        roomId = item['room_id'],
        roomNumber = item['room_number'],
        type = item['type'],
        price = item['price'],
        hotelId = item['hotel_id'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'img': img,
      'room_id': roomId,
      'room_number': roomNumber,
      'type': type,
      'price': price,
      'hotel_id': hotelId,
    };
  }
}

class HotelAvalibleModel {
  final int hotelId;
  final String name;
  final String address;
  final String city;
  final String img;
  final double ratings;
  final double min_price;
  HotelAvalibleModel({
    required this.hotelId,
    required this.name,
    required this.address,
    required this.city,
    required this.img,
    required this.ratings,
    required this.min_price,
  });
  HotelAvalibleModel.fromMap(Map<String, dynamic> item)
      : hotelId = item['hotel_id'],
        name = item['name'],
        address = item['address'],
        city = item['city'],
        img = item['img'],
        ratings = item['ratings'],
        min_price = item['min_price'];

  Map<String, Object?> toMap() {
    return {
      'hotel_id': hotelId,
      'name': name,
      'address': address,
      'city': city,
      'img': img,
      'ratings': ratings,
      'min_price': min_price,
    };
  }

  void sort(Function(dynamic a, dynamic b) param0) {}
}

class FacilitiesHotel {
  final int facilities_id;
  final String facilities_name;
  bool isChecked;

  FacilitiesHotel({
    required this.facilities_id,
    required this.facilities_name,
    this.isChecked = false,
  });

  FacilitiesHotel.fromMap(Map<String, dynamic> item)
      : facilities_id = item['facilities_id'],
        facilities_name = item['facilities_name'],
        isChecked = false;

  Map<String, Object?> toMap() {
    return {
      'facilities_id': facilities_id,
      'facilities_name': facilities_name,
    };
  }
}

class UserModel {
  String? id;
  String? email;
  String? lat;
  String? long;

  UserModel({
    this.id,
    this.email,
    this.lat,
    this.long,
  });
  UserModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        email = item['email'],
        lat = item['lat'],
        long = item['long'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'email': email,
      'lat': lat,
      'long': long,
    };
  }
}

class HotelAllModel {
  final int hotelId;
  final String name;
  final String address;
  final String city;
  final String img;
  final double ratings;
  final double min_price;
  final String lat;
  final String long;
  double? displacement;

  HotelAllModel({
    required this.hotelId,
    required this.name,
    required this.address,
    required this.city,
    required this.img,
    required this.ratings,
    required this.min_price,
    required this.lat,
    required this.long,
    this.displacement,
  });
  HotelAllModel.fromMap(Map<String, dynamic> item)
      : hotelId = item['hotel_id'],
        name = item['name'],
        address = item['address'],
        city = item['city'],
        img = item['img'],
        ratings = item['ratings'],
        min_price = item['min_price'],
        lat = item['lat'],
        long = item['long'],
        displacement = item['displacement'];

  Map<String, Object?> toMap() {
    return {
      'hotel_id': hotelId,
      'name': name,
      'address': address,
      'city': city,
      'img': img,
      'ratings': ratings,
      'min_price': min_price,
      'lat': lat,
      'long': long,
      'displacement': displacement,
    };
  }
}

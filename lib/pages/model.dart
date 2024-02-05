class HotelModel {
  final int? id;
  final String name;
  final String address;
  final String city;
  final String img;
  HotelModel({
    this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.img,
  });
  HotelModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        address = item['address'],
        city = item['city'],
        img = item['img'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'img': img
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

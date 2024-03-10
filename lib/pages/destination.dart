import 'package:book_and_rest/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:geocoding/geocoding.dart';

class destination extends StatefulWidget {
  const destination({super.key});

  @override
  State<destination> createState() => _destination();
}

class _destination extends State<destination> {
  List<String> thaiProvinces = [
    'Bangkok',
    'Samut Prakan',
    'Nonthaburi',
    'Pathum Thani',
    'Samut Sakhon',
    'Nakhon Pathom',
    'Phra Nakhon Si Ayutthaya',
    'Ang Thong',
    'Lop Buri',
    'Sing Buri',
    'Chai Nat',
    'Saraburi',
    'Chon Buri',
    'Rayong',
    'Chanthaburi',
    'Trat',
    'Chachoengsao',
    'Prachin Buri',
    'Nakhon Nayok',
    'Sa Kaeo',
    'Nakhon Ratchasima',
    'Buri Ram',
    'Surin',
    'Si Sa Ket',
    'Ubon Ratchathani',
    'Yasothon',
    'Chaiyaphum',
    'Amnat Charoen',
    'Bueng Kan',
    'Nong Bua Lamphu',
    'Khon Kaen',
    'Udon Thani',
    'Loei',
    'Nong Khai',
    'Maha Sarakham',
    'Roi Et',
    'Kalasin',
    'Sakon Nakhon',
    'Nakhon Phanom',
    'Mukdahan',
    'Chiang Mai',
    'Lamphun',
    'Lampang',
    'Uttaradit',
    'Phitsanulok',
    'Sukhothai',
    'Phichit',
    'Phetchabun',
    'Ratchaburi',
    'Kanchanaburi',
    'Suphan Buri',
    'Nakhon Pathom',
    'Samut Sakhon',
    'Samut Songkhram',
    'Phetchaburi',
    'Prachuap Khiri Khan',
    'Nakhon Si Thammarat',
    'Krabi',
    'Phang Nga',
    'Phuket',
    'Surat Thani',
    'Ranong',
    'Chumphon',
    'Prachuap Khiri Khan',
    'Nakhon Si Thammarat',
    'Krabi',
    'Phang Nga',
    'Phuket',
    'Surat Thani',
    'Ranong',
    'Chumphon',
    'Songkhla',
    'Satun',
    'Trang',
    'Phatthalung',
    'Pattani',
    'Yala'
  ];

  Future<List<String>> searchThaiProvinces(String query) async {
    // สำหรับตอนนี้เราจะใช้ข้อมูลจังหวัดที่มีอยู่แล้วเป็นตัวอย่าง
    // ในการค้นหาจะสามารถทำได้โดยการกรองข้อมูลจากรายชื่อจังหวัด
    return thaiProvinces
        .where(
            (province) => province.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> _filterProvince = [];
  String? userLatLng;
  @override
  void initState() {
    _filterProvince = thaiProvinces;
    super.initState();
    _runFilter('');
    initializeUserLocation();
  }

  Future<void> initializeUserLocation() async {
    userLatLng = await UserPreferences.getLatLng();
    setState(() {});
  }

  void _runFilter(String enteredKeyword) {
    List<String> result = [];
    if (enteredKeyword.isEmpty) {
      // result = thaiProvinces;
      result = ['Near my location'];
    } else {
      result = thaiProvinces
          .where((searchProvince) => searchProvince
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filterProvince = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Thai Provinces'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => _runFilter(value),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filterProvince.length,
                  itemBuilder: (context, index) {
                    var province = _filterProvince[index];
                    print('****** : $province');
                    return ListTile(
                      title: Text(province),
                      leading: province != 'Near my location'
                          ? Icon(Icons.location_city)
                          : Icon(Symbols.gps_fixed),
                      onTap: () async {
                        //เลือกจังหวัดที่ต้องการส่งค่ากลับไป
                        if (province == "Near my location") {
                          if (userLatLng != null) {
                            List<String> latLng = userLatLng!.split(',');
                            double Lat = double.parse(latLng[0]);
                            double Lng = double.parse(latLng[1]);
                            // ใช้ค่า Lat และ Lng ต่อไป
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(Lat, Lng);
                            Placemark placeMark = placemarks[0];
                            province = placeMark.administrativeArea!;
                          }
                        }
                        Navigator.pop(context, province);
                        print('======$province=======');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

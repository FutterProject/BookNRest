import 'package:book_and_rest/pages/database.dart';
import 'package:book_and_rest/pages/model.dart';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _Filter();
}

class _Filter extends State<Filter> {
  RangeValues _currentRangeValues = const RangeValues(0, 160);
  final appDatabase db = appDatabase();
  List<FacilitiesHotel>? facilities;

  @override
  void initState() {
    super.initState();
    loadFacilities();
  }

  Future<void> loadFacilities() async {
    facilities = await db.getFacilities();
    setState(() {});
  }

  void filterAndReturn() {
// สร้าง list ของ facilities ที่ถูกเลือก
    List<FacilitiesHotel> selectedFacilities =
        facilities!.where((facility) => facility.isChecked).toList();
    for (FacilitiesHotel facility in selectedFacilities) {
      print(
          'Facility: ${facility.facilities_name}, Is Checked: ${facility.isChecked}');
    }
    List<int> selectedFacilityIds =
        selectedFacilities.map((facility) => facility.facilities_id).toList();

    for (FacilitiesHotel facility in selectedFacilities) {
      print(
          'Facility: ${facility.facilities_name}, Is Checked: ${facility.isChecked}');
    }
    print("Selected Facility IDs: $selectedFacilityIds");

// ส่ง Map นี้กลับไปยังหน้าก่อนหน้า
    // Navigator.pop(context, selectedFacilityIds);
    Navigator.pop(context, {
      'selectedFacilityIds': selectedFacilityIds,
      'startRangeValue': _currentRangeValues.start.round(),
      'endRangeValue': _currentRangeValues.end.round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Budget",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text("\$ ${_currentRangeValues.start.round().toString()}"),
                  Spacer(),
                  Text("\$ ${_currentRangeValues.end.round().toString()}")
                ],
              ),
              RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 160,
                divisions: 10,
                labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString()),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
              // Text(
              //   'Ratings',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // GestureDetector(
              //   child: Text("5 Star"),
              // ),
              Text(
                'Efficiency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _BuildFacility(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: filterAndReturn,
                    child: Text('Filtered'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildFacility() {
    if (facilities == null) {
      return CircularProgressIndicator(); // แสดงตัวโหลดขณะรอข้อมูล
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: facilities!.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(facilities![index].facilities_name),
              value: facilities![index].isChecked,
              onChanged: (bool? value) {
                setState(() {
                  facilities![index].isChecked = value ?? false;
                  print(
                      'Facility: ${facilities![index].facilities_name}, Is Checked: ${facilities![index].isChecked}');
                });
              },
            );
          },
        ),
      );
    }
  }
}

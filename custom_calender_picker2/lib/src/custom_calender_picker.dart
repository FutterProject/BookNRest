import '../src/custom_calender_picker_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalenderPicker extends StatefulWidget {
  const CustomCalenderPicker({
    this.returnDateType = ReturnDateType.list,
    this.initialDateList,
    this.initialDateRange,
    this.selectedColor = const Color(0xff3581FF),
    this.rangeColor = Colors.grey,
    this.selectedFontColor,
    this.calenderThema = CalenderThema.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.buttonColor = const Color(0xff3581FF),
    this.buttonText = 'OK',
    this.buttonTextColor = Colors.white,
    this.minDate, // เพิ่มตรงนี้
    this.maxDate, // เพิ่มตรงนี้
    Key? key,
  }) : super(key: key);

  final ReturnDateType returnDateType;
  final List<DateTime>? initialDateList;
  final DateTimeRange? initialDateRange;
  final Color selectedColor;
  final Color rangeColor;
  final Color? selectedFontColor;
  final CalenderThema calenderThema;
  final BorderRadius borderRadius;
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;
  final DateTime? minDate; // เพิ่มตรงนี้
  final DateTime? maxDate; // เพิ่มตรงนี้

  @override
  State<CustomCalenderPicker> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<CustomCalenderPicker> {
  final List<DateTime> _calender = [];

  final List<DateTime> _selectedDateList = [];

  DateTime? _selectRangeStart;
  DateTime? _selectRangeEnd;

  late Color _selectedFontColor;

  late DateTime _viewMonth;

  @override
  void initState() {
    super.initState();

    if (widget.returnDateType == ReturnDateType.list) {
      _selectedDateList.addAll(widget.initialDateList ?? []);
    } else {
      _selectRangeStart = widget.initialDateRange?.start;
      _selectRangeEnd = widget.initialDateRange?.end;
    }

    _viewMonth = DateTime.now();
    _selectedFontColor = widget.selectedFontColor != null
        ? widget.selectedFontColor!
        : widget.calenderThema == CalenderThema.dark
            ? const Color(0xFF2C2C2C)
            : Colors.white;

    viewCalender();
    setState(() {});
  }

  List<String> weekNames = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  void viewCalender() {
    _calender.clear();

    int startWeekDay =
        DateTime(_viewMonth.year, _viewMonth.month, 1).weekday == 7
            ? 0
            : DateTime(_viewMonth.year, _viewMonth.month, 1).weekday;

    for (int i = 1; i <= 42; i++) {
      _calender
          .add(DateTime(_viewMonth.year, _viewMonth.month, i - startWeekDay));
    }
  }

  void goBackMonth() {
    DateTime newMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1);
    final DateTime now = DateTime.now();
    if (newMonth.isAfter(now) || newMonth.month == now.month) {
      _viewMonth = newMonth;
      viewCalender();
    }
  }

  void goFrontMonth() {
    DateTime newMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
    final DateTime now = DateTime.now();
    if (newMonth.isBefore(now.add(Duration(days: 365)))) {
      _viewMonth = newMonth;
      viewCalender();
    }
  }

  void selectDate(DateTime date) {
    if (!_selectedDateList.contains(date) &&
        (widget.minDate == null || date.isAfter(widget.minDate!)) &&
        (widget.maxDate == null || date.isBefore(widget.maxDate!))) {
      _selectedDateList.add(date);
    } else {
      _selectedDateList.removeWhere((e) =>
          e.year == date.year && e.month == date.month && e.day == date.day);
    }
  }

  void selectDateRange(DateTime date) {
    bool withinDateRange = (widget.minDate == null ||
            (date.isAfter(widget.minDate!) ||
                (DateTime.now().day == date.day))) &&
        (widget.maxDate == null || date.isBefore(widget.maxDate!));
    print('within bool : $withinDateRange');
    //ถ้าไม่อยู่ในช่วงจะไม่ทำอะไรเลย
    if (!withinDateRange) return;
    //เงื่อนไข เลือก วันแรก และ วันท้ายแล้ว ต้องการเปลี่ยนวัน
    if (_selectRangeStart != null && _selectRangeEnd != null) {
      _selectRangeStart = date;
      _selectRangeEnd = null;
    } else if (_selectRangeStart == null) {
      //เงื่อนไข ถ้ายังไม่ได้เลือกวัน แล้วกดเลือก เวลาที่อยู่ในช่วงจะเซ็ต จะเป็นวันแรก
      _selectRangeStart = date;
      print('ยังไม่ได้เลือกวัน[วันแรก] : $_selectRangeStart');
    } else if (date.isBefore(_selectRangeStart!)) {
      //ถ้าเลือกวันที่ก่อน วันที่แรกที่เลือกไปแล้ว จะเซ็ตที่เลือกใหม่เป็นวันแรกแทน
      _selectRangeStart = date;
    } else if (date.isAfter(_selectRangeStart!)) {
      //ถ้าเลือกวันที่หลัง วันที่แรกที่เลือกไปแล้วจะเลือกเป็น วันสุดท้าย
      _selectRangeEnd = date;
    } else if (_selectRangeStart == date) {
      //ถ้าเลือกวันที่เลือกไปแล้วจะยกเลิกวันที่เลือกไว้
      _selectRangeStart = null;
      print('ยกเลือก : $_selectRangeStart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: widget.calenderThema == CalenderThema.dark
            ? const Color(0xFF2C2C2C)
            : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  goBackMonth();
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: widget.calenderThema == CalenderThema.dark
                        ? Colors.white
                        : const Color(0xFF2C2C2C),
                  ),
                ),
              ),
              Text(
                '${_viewMonth.year} ${DateFormat('MMMM').format(_viewMonth)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.calenderThema == CalenderThema.dark
                      ? Colors.white
                      : const Color(0xFF2C2C2C),
                ),
              ),
              GestureDetector(
                onTap: () {
                  goFrontMonth();
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: widget.calenderThema == CalenderThema.dark
                        ? Colors.white
                        : const Color(0xFF2C2C2C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ...List.generate(
                7,
                (index) => Expanded(
                  child: Text(
                    weekNames[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: index == 0
                          ? Colors.red
                          : index == 6
                              ? const Color(0xff3581FF)
                              : widget.calenderThema == CalenderThema.dark
                                  ? Colors.white
                                  : const Color(0xFF2C2C2C),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(
                6,
                (index1) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ...List.generate(
                        7,
                        (index2) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              DateTime selectedDate =
                                  _calender[index1 * 7 + index2];
                              if ((widget.minDate == null ||
                                      (selectedDate.isAfter(widget.minDate!) ||
                                          (DateTime.now().day ==
                                              selectedDate.day))) &&
                                  (widget.maxDate == null ||
                                      selectedDate.isBefore(widget.maxDate!))) {
                                if (selectedDate.month != _viewMonth.month) {
                                  _viewMonth = DateTime(
                                      selectedDate.year, selectedDate.month);
                                  viewCalender();
                                }
                                if (widget.returnDateType ==
                                    ReturnDateType.list) {
                                  selectDate(selectedDate);
                                } else {
                                  selectDateRange(selectedDate);
                                }
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.returnDateType ==
                                            ReturnDateType.range &&
                                        _selectRangeStart != null &&
                                        _selectRangeEnd != null &&
                                        (_selectRangeStart!.isBefore(_calender[
                                                index1 * 7 + index2]) &&
                                            _selectRangeEnd!.isAfter(
                                              _calender[index1 * 7 + index2]
                                                  .add(const Duration(
                                                      hours: 23,
                                                      minutes: 59,
                                                      seconds: 59)),
                                            ))
                                    ? widget.rangeColor
                                    : null,
                                gradient: _rangeGradient(
                                    _calender[index1 * 7 + index2]),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _dayBoxColor(
                                      _calender[index1 * 7 + index2]),
                                ),
                                child: Text(
                                  _calender[index1 * 7 + index2].day.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: dayTextColor(
                                        _calender[index1 * 7 + index2]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  fixedSize: const Size.fromHeight(48),
                  backgroundColor: widget.buttonColor,
                ),
                onPressed: () {
                  if (widget.returnDateType == ReturnDateType.list) {
                    _selectedDateList.sort();
                    Navigator.of(context).pop(_selectedDateList);
                  } else {
                    if (_selectRangeStart == null || _selectRangeEnd == null) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop(DateTimeRange(
                          start: _selectRangeStart!, end: _selectRangeEnd!));
                    }
                  }
                },
                child: Text(
                  widget.buttonText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: widget.buttonTextColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Color _dayBoxColor(DateTime date) {
    // bool withinDateRange =
    //     (widget.minDate == null || date.isAfter(widget.minDate!)) &&
    //         (widget.maxDate == null || date.isBefore(widget.maxDate!));
    // if (!withinDateRange) {
    //   return Colors.redAccent;
    // }
    return widget.returnDateType == ReturnDateType.list
        ? _selectedDateList.indexWhere((e) =>
                    e.year == date.year &&
                    e.month == date.month &&
                    e.day == date.day) !=
                -1
            ? widget.selectedColor
            : Colors.transparent
        : ((_selectRangeStart?.year == date.year &&
                    _selectRangeStart?.month == date.month &&
                    _selectRangeStart?.day == date.day) ||
                (_selectRangeEnd?.year == date.year &&
                    _selectRangeEnd?.month == date.month &&
                    _selectRangeEnd?.day == date.day))
            ? widget.selectedColor
            : Colors.transparent;
  }

  Color dayTextColor(DateTime date) {
    bool withinDateRange = (widget.minDate == null ||
            (date.isAfter(widget.minDate!) ||
                (DateTime.now().day == date.day))) &&
        (widget.maxDate == null || date.isBefore(widget.maxDate!));

    if (!withinDateRange) {
      return Colors.grey; // ถ้าวันที่ไม่อยู่ในช่วง ให้สีของข้อความเป็นสีเทา
    }
    return widget.returnDateType == ReturnDateType.list
        ? _selectedDateList.indexWhere((e) =>
                    e.year == date.year &&
                    e.month == date.month &&
                    e.day == date.day) !=
                -1
            ? _selectedFontColor
            : date.month != _viewMonth.month
                ? Colors.grey
                : date.weekday == 6
                    ? const Color(0xff3581FF)
                    : date.weekday == 7
                        ? Colors.red
                        : widget.calenderThema == CalenderThema.dark
                            ? Colors.white
                            : const Color(0xFF2C2C2C)
        : ((_selectRangeStart?.year == date.year &&
                    _selectRangeStart?.month == date.month &&
                    _selectRangeStart?.day == date.day) ||
                (_selectRangeEnd?.year == date.year &&
                    _selectRangeEnd?.month == date.month &&
                    _selectRangeEnd?.day == date.day))
            ? _selectedFontColor
            : date.month != _viewMonth.month
                ? Colors.grey
                // : date.weekday == 6
                //     ? const Color(0xff3581FF)
                //     : date.weekday == 7
                //         ? Colors.red
                : widget.calenderThema == CalenderThema.dark
                    ? Colors.white
                    : const Color(0xFF2C2C2C);
  }

  LinearGradient? _rangeGradient(DateTime date) {
    if (_selectRangeStart != null && _selectRangeEnd != null) {
      if (_selectRangeStart?.year == date.year &&
          _selectRangeStart?.month == date.month &&
          _selectRangeStart?.day == date.day) {
        return LinearGradient(
          tileMode: TileMode.clamp,
          colors: [
            Colors.transparent,
            widget.rangeColor,
          ],
          stops: const [.4, .5],
        );
      } else if (_selectRangeEnd?.year == date.year &&
          _selectRangeEnd?.month == date.month &&
          _selectRangeEnd?.day == date.day) {
        return LinearGradient(
          tileMode: TileMode.clamp,
          colors: [
            widget.rangeColor,
            Colors.transparent,
          ],
          stops: const [.4, .5],
        );
      }
    } else {
      return null;
    }
    return null;
  }
}

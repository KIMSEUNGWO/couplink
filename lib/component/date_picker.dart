
import 'package:couplink_app/component/DatePicker.dart';
import 'package:couplink_app/component/FontTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateTimePick {
  bool isAllDay = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  DateTime startDateToFinal() {
    if (isAllDay) {
      return DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
    }
    return startDate;
  }
  DateTime endDateToFinal() {
    if (isAllDay) {
      return DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    }
    return endDate;
  }
  init() {
    startDate = DateTime(startDate.year, startDate.month, startDate.day, startDate.hour + 1, 0);
    endDate = DateTime(startDate.year, startDate.month, startDate.day, startDate.hour + 1, 0);
  }
  void setIsAllDay(bool isOn) {
    isAllDay = isOn;
  }

  void setStartDate(DateTime dateTime) {
    startDate = DateTime(dateTime.year, dateTime.month, dateTime.day, startDate.hour, startDate.minute);
    if (startDate.isAfter(endDate)) {
      endDate = DateTime(startDate.year, startDate.month, startDate.day, startDate.hour, startDate.minute);
    }
  }
  void setStartTime(DateTime dateTime) {
    startDate = DateTime(startDate.year, startDate.month, startDate.day, dateTime.hour, dateTime.minute);
    if (startDate.isAfter(endDate)) {
      endDate = DateTime(startDate.year, startDate.month, startDate.day, startDate.hour, startDate.minute);
    }
  }
  void setEndDate(DateTime dateTime) {
    endDate = DateTime(dateTime.year, dateTime.month, dateTime.day, endDate.hour, endDate.minute);
    if (startDate.isAfter(endDate)) {
      startDate = DateTime(endDate.year, endDate.month, endDate.day, endDate.hour, endDate.minute);
    }
  }
  void setEndTime(DateTime dateTime) {
    endDate = DateTime(endDate.year, endDate.month, endDate.day, dateTime.hour, dateTime.minute);
    if (startDate.isAfter(endDate)) {
      startDate = DateTime(endDate.year, endDate.month, endDate.day, endDate.hour, endDate.minute);
    }
  }
}
class DatePickerWidget extends StatelessWidget {

  final Function(DateTime dateTime) onDateChange;
  final DateTime dateTime;
  const DatePickerWidget({super.key, required this.onDateChange, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatePicker().selectDate(context, onPressed: onDateChange, initDate: dateTime);
      },
      child: Container(
        width: 95, height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(DateFormat('yyyy. MM. dd.').format(dateTime),
            style: FontTheme.of(context,
              size: FontSize.bodyLarge,
              fontColor: FontColor.f1,
            ),
          ),
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatelessWidget {
  final Function(DateTime dateTime) onTimeChange;
  final DateTime dateTime;
  const TimePickerWidget({super.key, required this.onTimeChange, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatePicker().selectTime(context,
          onPressed: onTimeChange,
          initDate: dateTime,
        );
      },
      child: Container(
        width: 55, height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(DateFormat('HH:mm').format(dateTime),
            style: FontTheme.of(context,
              size: FontSize.bodyLarge,
              fontColor: FontColor.f1,
            ),
          ),
        ),
      ),
    );;
  }
}

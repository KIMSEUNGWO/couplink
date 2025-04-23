
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker {

  Future<void> selectDate(BuildContext context, {required Function(DateTime date) onPressed, required DateTime initDate}) async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, // showCupertinoDialog 영역 외에 눌렀을 때 닫게 해줌
      builder: (BuildContext context) {
        return SelectDateModal(
          onPressed: onPressed,
          initDate: initDate,
        );
      },
    );
  }
  Future<void> selectTime(BuildContext context, {required Function(DateTime date) onPressed, required DateTime initDate}) async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, // showCupertinoDialog 영역 외에 눌렀을 때 닫게 해줌
      builder: (BuildContext context) {
        return SelectTimeModal(
          onPressed: onPressed,
          initTime: initDate,
        );
      },
    );
  }

}
class SelectDateModal extends StatefulWidget {
  final Function(DateTime date) onPressed;
  final DateTime initDate;

  const SelectDateModal({super.key, required this.onPressed, required this.initDate});

  @override
  State<SelectDateModal> createState() => _SelectDateModalState();
}

class _SelectDateModalState extends State<SelectDateModal> {

  DateTime? _select;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment
          .bottomCenter, //특정 위젯이 어디에 정렬을 해야되는지 모르면 height값줘도 최대한에 사이즈를 먹음
      child: Container(
        color: Colors.white,
        height: 300,
        child: Column(
          children: [
            CupertinoButton(
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text('완료',
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              onPressed: () {
                if (_select != null) {
                  widget.onPressed(_select!);
                }
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date, //CupertinoDatePickerMode에서 일시, 시간 등 고름
                initialDateTime: widget.initDate,

                onDateTimeChanged: (DateTime date) {
                  _select = date;
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectTimeModal extends StatefulWidget {
  final Function(DateTime date) onPressed;
  final DateTime initTime;

  const SelectTimeModal({super.key, required this.onPressed, required this.initTime});

  @override
  State<SelectTimeModal> createState() => _SelectTimeModalState();
}

class _SelectTimeModalState extends State<SelectTimeModal> {

  DateTime? _select;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment
          .bottomCenter, //특정 위젯이 어디에 정렬을 해야되는지 모르면 height값줘도 최대한에 사이즈를 먹음
      child: Container(
        color: Colors.white,
        height: 300,
        child: Column(
          children: [
            CupertinoButton(
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text('완료',
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              onPressed: () {
                if (_select != null) {
                  widget.onPressed(_select!);
                }
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: widget.initTime,

                onDateTimeChanged: (DateTime date) {
                  _select = date;
                },

              ),
            ),
          ],
        ),
      ),
    );;
  }
}

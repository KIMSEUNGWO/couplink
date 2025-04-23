
import 'package:couplink_app/component/add_event_button.dart';
import 'package:couplink_app/cr_calendar/src/cr_calendar.dart';
import 'package:couplink_app/cr_calendar/src/models/calendar_event_model.dart';
import 'package:couplink_app/entity/Event.dart';
import 'package:couplink_app/service/EventCalendarService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  final Map<int, String> week = const {
    0 : '일', 1 : '월', 2 : '화', 3 : '수', 4 : '목', 5 : '금', 6 : '토',
  };
  final Map<int, Color> weekColor = const {
    0 : Color(0xFFEF4223),
    6 : Color(0xFF3F9DE0),
  };
  int index = 0;

  late final CrCalendarController _calendarController;
  DateTime _currentDate = DateTime.now();

  CalendarEventModel _convert(Event event) {
    return CalendarEventModel(
      id: event.eventId,
      name: event.title,
      begin: event.startDate,
      end: event.endDate,
      eventColor: Color(event.color)
    );
  }

  add(Event event) {
    _calendarController.addEvent(_convert(event));
  }
  edit(Event event) {

  }
  _onSwipe(int year, int month) {
    setState(() {
      _currentDate = DateTime(year, month);
    });

    _calendarController.addEvents(
        EventCalendarService().getEventsForMonth(year, month).map((event) => _convert(event)).toList()
    );

  }

  @override
  void initState() {
    _calendarController = CrCalendarController(
      onSwipe: _onSwipe,
      events: EventCalendarService().getEventsForMonth(_currentDate.year, _currentDate.month)
          .map((event) => _convert(event)).toList(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy년 M월').format(_currentDate)),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          CrCalendar(
          forceSixWeek: true,
          eventsTopPadding: 27,
          eventBuilder: (eventDrawer) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: eventDrawer.backgroundColor,
                borderRadius: BorderRadius.circular(4)
              ),
              child: Text(eventDrawer.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11
                ),
              ),
            );
          },
          weekDaysBuilder: (day) {
            return Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(week[day.index]!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: day.index == 0 || day.index == 6
                    ? weekColor[day.index]
                    : Theme.of(context).colorScheme.tertiary,
                ),
              ),
            );
          },
          dayItemBuilder: (properties) {
            int inIndex = index % 7;
            index++;

            bool isInMonth = properties.isInMonth;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 0.5),
                color: !isInMonth
                    ? const Color(0xFFF1F3F5)
                    : Colors.white,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 22,
                  height: 22,
                  // 원형 모양 및 배경색 설정
                  decoration: properties.isCurrentDay ?BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.onPrimary
                  ) : null,
                  child: Center(
                    child: Text(properties.dayNumber.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: !isInMonth ? Theme.of(context).colorScheme.tertiary
                          : properties.isCurrentDay ? Colors.white
                          : inIndex == 0 || inIndex == 6 ? weekColor[inIndex]
                          : Theme.of(context).colorScheme.secondary,
                      ),

                    ),
                  ),
                ),
              ),
            );
          },

          controller: _calendarController,
          initialDate: DateTime.now(),

        ),
          Positioned(
            right: 20, bottom: 20,
            child: AddEventButton(
              add: add,
              edit: edit,
            ),
          )
        ]
      ),
    );
  }
}


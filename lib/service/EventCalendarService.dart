
import 'package:couplink_app/entity/Event.dart';
import 'package:hive/hive.dart';

class EventCalendarService {
  static final EventCalendarService _instance = EventCalendarService._internal();
  factory EventCalendarService() => _instance;

  late Box<Event> eventBox;

  // 연-월 별로 이벤트 ID를 매핑하는 캐시
  final Map<String, List<String>> _monthlyEventCache = {};

  EventCalendarService._internal();

  Future<void> init(Box<Event> eventBox) async {
    this.eventBox = eventBox;
    await _buildMonthlyIndices();
  }

  // 시작할 때 월별 인덱스 구축
  Future<void> _buildMonthlyIndices() async {
    for (var event in eventBox.values) {
      _addEventToMonthlyIndices(event);
    }
  }

  // 월별 인덱스에 이벤트 추가
  void _addEventToMonthlyIndices(Event event) {
    // 이벤트의 시작일부터 종료일까지 각 월에 이벤트 ID 추가
    DateTime current = DateTime(event.startDate.year, event.startDate.month, 1);
    final end = DateTime(event.endDate.year, event.endDate.month, 1);

    while (!current.isAfter(end)) {
      final key = '${current.year}-${current.month.toString().padLeft(2, '0')}';
      _monthlyEventCache.putIfAbsent(key, () => []);

      if (!_monthlyEventCache[key]!.contains(event.eventId)) {
        _monthlyEventCache[key]!.add(event.eventId);
      }

      // 다음 달로 이동
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1, 1);
    }
  }

  // 이벤트 추가 또는 업데이트
  Future<void> put(String eventId, Event event) async {
    // 기존 이벤트가 있으면 캐시에서 제거
    if (eventBox.containsKey(eventId)) {
      final oldEvent = eventBox.get(eventId);
      if (oldEvent != null) {
        _removeEventFromMonthlyIndices(oldEvent);
      }
    }

    // 이벤트 저장 및 인덱스 업데이트
    await eventBox.put(eventId, event);
    _addEventToMonthlyIndices(event);
  }

  // 이벤트를 월별 인덱스에서 제거
  void _removeEventFromMonthlyIndices(Event event) {
    DateTime current = DateTime(event.startDate.year, event.startDate.month, 1);
    final end = DateTime(event.endDate.year, event.endDate.month, 1);

    while (!current.isAfter(end)) {
      final key = '${current.year}-${current.month.toString().padLeft(2, '0')}';
      if (_monthlyEventCache.containsKey(key)) {
        _monthlyEventCache[key]!.remove(event.eventId);
      }

      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1, 1);
    }
  }

  // 특정 월(6주 캘린더)에 해당하는 이벤트 가져오기
  List<Event> getEventsForMonth(int year, int month) {

    // 해당 월의 캘린더 6주 범위 계산
    final firstDayOfMonth = DateTime(year, month, 1);
    int startWeekday = firstDayOfMonth.weekday % 7; // 0이 일요일

    // 캘린더에 표시될 첫 날(이전 달 일부 포함)
    final calendarStart = firstDayOfMonth.subtract(Duration(days: startWeekday));

    // 캘린더에 표시될 마지막 날(6주 후)
    final calendarEnd = calendarStart.add(const Duration(days: 41)); // 6주 = 42일, 41은 마지막 날

    // 캘린더에 포함되는 모든 월의 키 수집
    final Set<String> keysToCheck = {};
    DateTime current = DateTime(calendarStart.year, calendarStart.month, 1);

    while (!current.isAfter(DateTime(calendarEnd.year, calendarEnd.month, 1))) {
      keysToCheck.add('${current.year}-${current.month.toString().padLeft(2, '0')}');
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1, 1);
    }

    // 캐시된 인덱스를 사용하여 이벤트 ID 수집
    final Set<String> eventIds = {};
    for (var key in keysToCheck) {
      if (_monthlyEventCache.containsKey(key)) {
        eventIds.addAll(_monthlyEventCache[key]!);
      }
    }

    // 이벤트 가져오기
    final events = eventIds.map((id) => eventBox.get(id)).whereType<Event>().toList();

    // 추가 필터링: 실제로 캘린더 범위에 있는 이벤트만 필터링
    return events.where((event) =>
    !(event.endDate.isBefore(calendarStart) || event.startDate.isAfter(calendarEnd))
    ).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate)); // 정렬
  }

  // 이벤트 삭제
  Future<void> delete(int eventId) async {
    if (eventBox.containsKey(eventId)) {
      final event = eventBox.get(eventId);
      if (event != null) {
        _removeEventFromMonthlyIndices(event);
      }
      await eventBox.delete(eventId);
    }
  }
}
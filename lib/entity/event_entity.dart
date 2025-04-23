
import 'dart:ui';

import 'package:hive/hive.dart';
part 'event_entity.g.dart';

@HiveType(typeId: 101)
enum AddEventType {

  @HiveField(0)
  NEW,
  @HiveField(1)
  EDIT
}
@HiveType(typeId: 102)
enum EventVisibility {

  @HiveField(0)
  SHARED(title: '공유'),
  @HiveField(1)
  PRIVATE(title: '비공개')
  ;
  final String title;

  const EventVisibility({required this.title});
}
@HiveType(typeId: 103)
enum EventTarget {

  @HiveField(0)
  ME(text: '나', color: Color(0xFF96C3FF)),
  @HiveField(1)
  YOU(text: '상대', color: Color(0xFFFF8D8F)),
  @HiveField(2)
  WE(text: '우리', color: Color(0xFF82DB85));

  final String text;
  final Color color;

  const EventTarget({required this.text, required this.color});
}

@HiveType(typeId: 104)
enum EventColor {

  @HiveField(0)
  AZURE(color: Color(0xFF4BACC6), title: '아주르', colorValue: 0xFF4BACC6),    // 터콰이즈 색상
  @HiveField(1)
  SKYLINE(color: Color(0xFF87CEEB), title: '스카이라인', colorValue: 0xFF87CEEB),    // 스카이블루 색상
  @HiveField(2)
  SUNSET(color: Color(0xFFED7D31), title: '선셋', colorValue: 0xFFED7D31),    // 오렌지 색상
  @HiveField(3)
  MEADOW(color: Color(0xFF70AD47), title: '메도우', colorValue: 0xFF70AD47),    // 그린 색상
  @HiveField(4)
  BLOSSOM(color: Color(0xFFC45A89), title: '블라썸', colorValue: 0xFFC45A89),    // 핑크 색상
  @HiveField(5)
  LAVENDER(color: Color(0xFF8064A2), title: '라벤더', colorValue: 0xFF8064A2),    // 퍼플 색상

  ;
  final Color color;
  final String title;
  final int colorValue;

  const EventColor({required this.color, required this.title, required this.colorValue});
}

@HiveType(typeId: 105)
enum EventSync {
  @HiveField(0)
  SYNCED,
  @HiveField(1)
  PENDING,
  @HiveField(2)
  CONLICT;
}
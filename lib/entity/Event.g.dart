// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      eventId: fields[0] as String,
      userId: fields[1] as int,
      title: fields[2] as String,
      target: fields[3] as EventTarget,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      visibility: fields[6] as EventVisibility,
      color: fields[7] as int,
      description: fields[8] as String?,
    )
      ..lastModified = fields[10] as DateTime?
      ..syncStatus = fields[11] as EventSync
      ..isDeleted = fields[12] as bool;
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.target)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.visibility)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.createAt)
      ..writeByte(10)
      ..write(obj.lastModified)
      ..writeByte(11)
      ..write(obj.syncStatus)
      ..writeByte(12)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

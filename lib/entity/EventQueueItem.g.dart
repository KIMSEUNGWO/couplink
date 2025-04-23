// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventQueueItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventQueueItemAdapter extends TypeAdapter<EventQueueItem> {
  @override
  final int typeId = 2;

  @override
  EventQueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventQueueItem(
      queueId: fields[0] as String,
      eventId: fields[1] as String,
      operationType: fields[2] as QueueOperation,
      eventData: (fields[3] as Map).cast<String, dynamic>(),
      timestamp: fields[4] as DateTime,
      retryCount: fields[5] as int,
      status: fields[6] as QueueStatus,
    );
  }

  @override
  void write(BinaryWriter writer, EventQueueItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.queueId)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.operationType)
      ..writeByte(3)
      ..write(obj.eventData)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.retryCount)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventQueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

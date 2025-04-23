// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_queue_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueueOperationAdapter extends TypeAdapter<QueueOperation> {
  @override
  final int typeId = 106;

  @override
  QueueOperation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueueOperation.CREATE;
      case 1:
        return QueueOperation.UPDATE;
      case 2:
        return QueueOperation.DELETE;
      default:
        return QueueOperation.CREATE;
    }
  }

  @override
  void write(BinaryWriter writer, QueueOperation obj) {
    switch (obj) {
      case QueueOperation.CREATE:
        writer.writeByte(0);
        break;
      case QueueOperation.UPDATE:
        writer.writeByte(1);
        break;
      case QueueOperation.DELETE:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueStatusAdapter extends TypeAdapter<QueueStatus> {
  @override
  final int typeId = 107;

  @override
  QueueStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueueStatus.PENDING;
      case 1:
        return QueueStatus.PROCESSING;
      case 2:
        return QueueStatus.FAILED;
      default:
        return QueueStatus.PENDING;
    }
  }

  @override
  void write(BinaryWriter writer, QueueStatus obj) {
    switch (obj) {
      case QueueStatus.PENDING:
        writer.writeByte(0);
        break;
      case QueueStatus.PROCESSING:
        writer.writeByte(1);
        break;
      case QueueStatus.FAILED:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

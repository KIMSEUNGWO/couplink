// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddEventTypeAdapter extends TypeAdapter<AddEventType> {
  @override
  final int typeId = 101;

  @override
  AddEventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AddEventType.NEW;
      case 1:
        return AddEventType.EDIT;
      default:
        return AddEventType.NEW;
    }
  }

  @override
  void write(BinaryWriter writer, AddEventType obj) {
    switch (obj) {
      case AddEventType.NEW:
        writer.writeByte(0);
        break;
      case AddEventType.EDIT:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddEventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventVisibilityAdapter extends TypeAdapter<EventVisibility> {
  @override
  final int typeId = 102;

  @override
  EventVisibility read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventVisibility.SHARED;
      case 1:
        return EventVisibility.PRIVATE;
      default:
        return EventVisibility.SHARED;
    }
  }

  @override
  void write(BinaryWriter writer, EventVisibility obj) {
    switch (obj) {
      case EventVisibility.SHARED:
        writer.writeByte(0);
        break;
      case EventVisibility.PRIVATE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventVisibilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTargetAdapter extends TypeAdapter<EventTarget> {
  @override
  final int typeId = 103;

  @override
  EventTarget read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventTarget.ME;
      case 1:
        return EventTarget.YOU;
      case 2:
        return EventTarget.WE;
      default:
        return EventTarget.ME;
    }
  }

  @override
  void write(BinaryWriter writer, EventTarget obj) {
    switch (obj) {
      case EventTarget.ME:
        writer.writeByte(0);
        break;
      case EventTarget.YOU:
        writer.writeByte(1);
        break;
      case EventTarget.WE:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTargetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventColorAdapter extends TypeAdapter<EventColor> {
  @override
  final int typeId = 104;

  @override
  EventColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventColor.AZURE;
      case 1:
        return EventColor.SKYLINE;
      case 2:
        return EventColor.SUNSET;
      case 3:
        return EventColor.MEADOW;
      case 4:
        return EventColor.BLOSSOM;
      case 5:
        return EventColor.LAVENDER;
      default:
        return EventColor.AZURE;
    }
  }

  @override
  void write(BinaryWriter writer, EventColor obj) {
    switch (obj) {
      case EventColor.AZURE:
        writer.writeByte(0);
        break;
      case EventColor.SKYLINE:
        writer.writeByte(1);
        break;
      case EventColor.SUNSET:
        writer.writeByte(2);
        break;
      case EventColor.MEADOW:
        writer.writeByte(3);
        break;
      case EventColor.BLOSSOM:
        writer.writeByte(4);
        break;
      case EventColor.LAVENDER:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventSyncAdapter extends TypeAdapter<EventSync> {
  @override
  final int typeId = 105;

  @override
  EventSync read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventSync.SYNCED;
      case 1:
        return EventSync.PENDING;
      case 2:
        return EventSync.CONLICT;
      default:
        return EventSync.SYNCED;
    }
  }

  @override
  void write(BinaryWriter writer, EventSync obj) {
    switch (obj) {
      case EventSync.SYNCED:
        writer.writeByte(0);
        break;
      case EventSync.PENDING:
        writer.writeByte(1);
        break;
      case EventSync.CONLICT:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventSyncAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

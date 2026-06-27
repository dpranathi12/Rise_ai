// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wake_up_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WakeUpHistoryAdapter extends TypeAdapter<WakeUpHistory> {
  @override
  final int typeId = 2;

  @override
  WakeUpHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WakeUpHistory(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      wakeUpTime: fields[2] as DateTime,
      exerciseType: fields[3] as String,
      repetitions: fields[4] as int,
      completionTimeSeconds: fields[5] as int,
      accuracyScore: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WakeUpHistory obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.wakeUpTime)
      ..writeByte(3)
      ..write(obj.exerciseType)
      ..writeByte(4)
      ..write(obj.repetitions)
      ..writeByte(5)
      ..write(obj.completionTimeSeconds)
      ..writeByte(6)
      ..write(obj.accuracyScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WakeUpHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

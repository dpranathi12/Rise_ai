// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmModelAdapter extends TypeAdapter<AlarmModel> {
  @override
  final int typeId = 0;

  @override
  AlarmModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmModel(
      id: fields[0] as String,
      time: fields[1] as DateTime,
      days: (fields[2] as List).cast<int>(),
      isEnabled: fields[3] as bool,
      soundPath: fields[4] as String,
      vibrate: fields[5] as bool,
      exerciseType: fields[6] as String,
      repetitions: fields[7] as int,
      difficulty: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.days)
      ..writeByte(3)
      ..write(obj.isEnabled)
      ..writeByte(4)
      ..write(obj.soundPath)
      ..writeByte(5)
      ..write(obj.vibrate)
      ..writeByte(6)
      ..write(obj.exerciseType)
      ..writeByte(7)
      ..write(obj.repetitions)
      ..writeByte(8)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

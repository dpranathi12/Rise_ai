// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      streakCount: fields[3] as int,
      totalWakeUps: fields[4] as int,
      totalSquats: fields[5] as int,
      totalXP: fields[6] as int,
      level: fields[7] as int,
      achievements: (fields[8] as List).cast<String>(),
      averageWakeUpQuality: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.streakCount)
      ..writeByte(4)
      ..write(obj.totalWakeUps)
      ..writeByte(5)
      ..write(obj.totalSquats)
      ..writeByte(6)
      ..write(obj.totalXP)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.achievements)
      ..writeByte(9)
      ..write(obj.averageWakeUpQuality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

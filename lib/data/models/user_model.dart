import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    super.token,
    super.hasPin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);

    // Map API 'accessToken' to 'token'
    if (modifiedJson.containsKey('accessToken')) {
      modifiedJson['token'] = modifiedJson['accessToken'];
    }

    // Handle missing 'id' - provide default as API doesn't return it
    if (modifiedJson['id'] == null) {
      modifiedJson['id'] = 'UNKNOWN_ID';
    } else {
      modifiedJson['id'] = modifiedJson['id'].toString();
    }

    // Handle missing 'username' - provide default as API doesn't return it
    if (modifiedJson['username'] == null) {
      modifiedJson['username'] = 'User';
    } else {
      modifiedJson['username'] = modifiedJson['username'].toString();
    }

    // Ensure token is String
    if (modifiedJson['token'] != null) {
      modifiedJson['token'] = modifiedJson['token'].toString();
    }

    // Handle hasPin (default to false if missing)
    if (modifiedJson['hasPin'] == null) {
      modifiedJson['hasPin'] = false;
    }

    // Since we are modifying the map to match what generated code likely expects or
    // we are going to manually construct it because the generated code won't know about our manual map mods for fields that don't match exactly without some help or we rely on the dynamic map.
    // Actually, `_$UserModelFromJson` uses the map values.
    // We need to make sure we return a UserModel derived from that.
    // But wait, `_$UserModelFromJson` calls the constructor. The constructor of `UserModel` calls `super`.
    // We need to verify `user_model.g.dart` handles `hasPin`? No, we can't edit .g.dart.
    // We should parse it manually here and pass it to the constructor if we were calling it directly,
    // OR we rely on `_$UserModelFromJson` if we added the field to the class.
    // BUT we cannot easily update .g.dart.
    // So we should instantiate UserModel MANUALLY to be safe and avoid .g.dart dependency for the new field until build_runner runs.

    // Manual instantiation to avoid .g.dart issues for the new field
    return UserModel(
      id: modifiedJson['id'] as String,
      username: modifiedJson['username'] as String,
      token: modifiedJson['token'] as String?,
      hasPin: modifiedJson['hasPin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'token': token,
    'hasPin': hasPin,
  };
}

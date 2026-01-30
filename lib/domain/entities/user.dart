import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String? token;
  final bool hasPin;

  const User({
    required this.id,
    required this.username,
    this.token,
    this.hasPin = false,
  });

  @override
  List<Object?> get props => [id, username, token, hasPin];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProfileScreenState extends Equatable {
  const ProfileScreenState({
    this.userName = '',
    this.userEmail = '',
    this.userAvatar = '',
    this.markerColor = Colors.red,
  });

  final String userName;
  final String userEmail;
  final String userAvatar;
  final Color markerColor;

  @override
  List<Object> get props => [
        userName,
        userEmail,
        userAvatar,
        markerColor,
      ];

  ProfileScreenState copyWith({
    String? userName,
    String? userEmail,
    String? userAvatar,
    Color? markerColor,
  }) {
    return ProfileScreenState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userAvatar: userAvatar ?? this.userAvatar,
      markerColor: markerColor ?? this.markerColor,
    );
  }
}

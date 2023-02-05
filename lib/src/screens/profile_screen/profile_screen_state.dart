import 'package:equatable/equatable.dart';

class ProfileScreenState extends Equatable {
  const ProfileScreenState({
    this.userName = '',
    this.userEmail = '',
    this.userAvatar = '',
  });

  final String userName;
  final String userEmail;
  final String userAvatar;

  @override
  List<Object> get props => [
        userName,
        userEmail,
        userAvatar,
      ];

  ProfileScreenState copyWith({
    String? userName,
    String? userEmail,
    String? userAvatar,
  }) {
    return ProfileScreenState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }
}

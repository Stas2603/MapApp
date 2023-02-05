import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String? name;
  final String? email;
  final String? avatarUrl;
  final String? latitude;
  final String? longitude;

  const UserInfo({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        avatarUrl,
        latitude,
        longitude,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
    );
  }
}

import 'package:equatable/equatable.dart';

class SelectedUserInfo extends Equatable {
  final String? name;
  final String? email;
  final String? avatarUrl;

  const SelectedUserInfo({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        avatarUrl,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:map_app/src/models/auth_user.dart';

class WelcomeScreenState extends Equatable {
  const WelcomeScreenState({
    this.userEmailList = const [],
    this.isRegisterPrevious = false,
    this.id = '',
  });

  final List<AuthUser> userEmailList;
  final bool isRegisterPrevious;
  final String id;

  @override
  List<Object> get props => [
        userEmailList,
        isRegisterPrevious,
        id,
      ];

  WelcomeScreenState copyWith({
    List<AuthUser>? userEmailList,
    bool? isRegisterPrevious,
    String? id,
  }) {
    return WelcomeScreenState(
      userEmailList: userEmailList ?? this.userEmailList,
      isRegisterPrevious: isRegisterPrevious ?? this.isRegisterPrevious,
      id: id ?? this.id,
    );
  }
}

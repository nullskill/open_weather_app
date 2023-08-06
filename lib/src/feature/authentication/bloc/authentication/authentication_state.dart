part of 'authentication_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

class AuthenticationState {
  final AppStatus status;
  final User user;

  const AuthenticationState._({
    required this.status,
    this.user = User.empty,
  });

  const AuthenticationState.authenticated(User user)
      : this._(
          status: AppStatus.authenticated,
          user: user,
        );

  const AuthenticationState.unauthenticated() : this._(status: AppStatus.unauthenticated);


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AuthenticationState &&
      other.status == status &&
      other.user == user;
  }

  @override
  int get hashCode => status.hashCode ^ user.hashCode;
}

part of 'authentication_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthenticationState {
  final AuthStatus status;
  final User user;

  const AuthenticationState._({
    required this.status,
    this.user = User.empty,
  });

  const AuthenticationState.authenticated(User user)
      : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  const AuthenticationState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationState && other.status == status && other.user == user;
  }

  @override
  int get hashCode => status.hashCode ^ user.hashCode;
}

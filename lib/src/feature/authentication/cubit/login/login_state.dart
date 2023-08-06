part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState {
  final String email;
  final String password;
  final String message;
  final LoginStatus status;

  const LoginState({
    required this.email,
    required this.password,
    required this.message,
    required this.status,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      message: '',
      status: LoginStatus.initial,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    String? message,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LoginState &&
      other.email == email &&
      other.password == password &&
      other.message == message &&
      other.status == status;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      password.hashCode ^
      message.hashCode ^
      status.hashCode;
  }
}

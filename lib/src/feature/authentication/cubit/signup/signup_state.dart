part of 'signup_cubit.dart';

enum SignUpStatus { initial, submitting, success, error }

class SignUpState {
  final String email;
  final String password;
  final String message;
  final SignUpStatus status;

  const SignUpState({
    required this.email,
    required this.password,
    required this.message,
    required this.status,
  });

  factory SignUpState.initial() {
    return const SignUpState(
      email: '',
      password: '',
      message: '',
      status: SignUpStatus.initial,
    );
  }

  SignUpState copyWith({
    String? email,
    String? password,
    String? message,
    SignUpStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SignUpState &&
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

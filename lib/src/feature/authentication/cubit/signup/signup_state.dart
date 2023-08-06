part of 'signup_cubit.dart';

enum SignUpStatus { initial, submitting, success, error }

class SignUpState {
  final String email;
  final String password;
  final SignUpStatus status;

  const SignUpState({
    required this.email,
    required this.password,
    required this.status,
  });

  factory SignUpState.initial() {
    return const SignUpState(
      email: '',
      password: '',
      status: SignUpStatus.initial,
    );
  }

  SignUpState copyWith({
    String? email,
    String? password,
    SignUpStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SignUpState &&
      other.email == email &&
      other.password == password &&
      other.status == status;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ status.hashCode;
}

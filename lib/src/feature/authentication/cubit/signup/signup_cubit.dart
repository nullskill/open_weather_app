import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/src/feature/authentication/data/authentication_repository.dart';
import 'package:open_weather_app/src/feature/authentication/model/firebase_auth_exception.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final IAuthenticationRepository _authenticationRepository;

  SignUpCubit(this._authenticationRepository) : super(SignUpState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignUpStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignUpStatus.initial,
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (state.status == SignUpStatus.submitting) return;
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _authenticationRepository.signUp(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } on FirebaseAuthException catch (error) {
      emit(state.copyWith(
        status: SignUpStatus.error,
        message: error.getAppFirebaseAuthExceptionType().message,
      ));
    }
  }
}

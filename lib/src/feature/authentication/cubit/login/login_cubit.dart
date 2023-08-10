 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_app/src/feature/authentication/data/authentication_repository.dart';
import 'package:open_weather_app/src/feature/authentication/model/firebase_auth_exception.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: LoginStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (error) {
      emit(state.copyWith(
        status: LoginStatus.error,
        message: error.getAppFirebaseAuthExceptionType().message,
      ));
    }
  }
}

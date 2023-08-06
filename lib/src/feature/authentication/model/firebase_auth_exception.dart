import 'package:firebase_auth/firebase_auth.dart';

enum AppFirebaseAuthExceptionType {
  none('none', message: 'Ошибка, проверьте введенные данные'),
  invalidEmail('invalid-email', message: 'Неправильный адрес электронной почты'),
  userDisabled('user-disabled', message: 'Этот пользователь заблокирован'),
  userNotFound('user-not-found', message: 'Такой пользователь не найден'),
  tooManyRequests('too-many-requests', message: 'Слишком много запросов'),
  popupBlockedByBrowser('popup-blocked-by-browser', message: 'Браузер заблокировал всплывающее окно'),
  wrongPassword('wrong-password', message: 'Неверный пароль'),
  emailAlreadyInUse('account-exists-with-different-credential',
      message: 'Такой адрес электронной почты уже зарегистрирован'),
  weakPassword('weak-password', message: 'Слишком простой пароль'),
  accountExist('account-exists-with-different-credential', message: 'Учетная запись уже существует'),
  invalidVerificationCode('invalid-verification-code', message: 'Неверный код подтверждения'),
  invalidVerificationId('invalid-verification-id', message: 'Неверный идентификатор подтверждения'),
  userMisMatch('user-mismatch', message: 'Несоответствие пользователей'),
  invalidCredential('invalid-credential', message: 'Неверные учетные данные'),
  networkUnavailable('network-request-failed', message: 'Проверьте подключение к интернету'),
  expiredActivationCode('expired-action-code', message: 'Срок действия кода активации истек');

  final String _code;
  final String message;

  const AppFirebaseAuthExceptionType(this._code, {required this.message});

  String get code => _code;
  static AppFirebaseAuthExceptionType getByCode(String? code) {
    return AppFirebaseAuthExceptionType.values.firstWhere(
      (element) => element.code == code,
      orElse: () => AppFirebaseAuthExceptionType.none,
    );
  }

  bool get isNone => this == AppFirebaseAuthExceptionType.none;
}

extension FirebaseErrorCode on FirebaseAuthException {
  AppFirebaseAuthExceptionType getAppFirebaseAuthExceptionType() {
    return AppFirebaseAuthExceptionType.getByCode(code);
  }
}

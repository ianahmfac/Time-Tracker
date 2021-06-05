import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/validator.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  String get buttonText {
    return formType == EmailSignInFormType.signIn ? 'Sign In' : 'Register';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? REGISTER'
        : 'Have an account? SIGN IN';
  }

  bool get isButtonEnabled {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get showPasswordError {
    bool isShowPasswordError =
        submitted && !passwordValidator.isValid(password);
    return isShowPasswordError ? invalidPasswordErrorText : null;
  }

  String? get showEmailError {
    bool isShowEmailError = submitted && !emailValidator.isValid(email);
    return isShowEmailError ? invalidEmailErrorText : null;
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;

    notifyListeners();
  }
}

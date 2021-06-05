import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:time_tracker/app/sign_in/validator.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      FocusManager.instance.primaryFocus!.unfocus();
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(email, password);
      } else {
        await auth.createUserWithEmail(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void changeFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

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

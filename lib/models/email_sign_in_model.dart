import 'package:time_tracker/app/sign_in/validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;
  EmailSignInModel({
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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}

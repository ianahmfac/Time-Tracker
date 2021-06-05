import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/bloc/email_sign_in_bloc.dart';
import 'package:time_tracker/models/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/form_submit_button.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class EmailSignInForm extends StatefulWidget {
  final EmailSignInBloc bloc;
  EmailSignInForm({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInForm(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.pop(context);
    } catch (e) {
      PlatformAlertDialog(
        titleText: 'Sign In Failed',
        contentText: e.toString(),
        buttonDialogText: 'OK',
      ).show(context);
    }
  }

  void _changeFormType() {
    _emailController.clear();
    _passwordController.clear();
    widget.bloc.changeFormType();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final model = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(model),
          ),
        );
      },
    );
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8),
      _buildPasswordTextField(model),
      SizedBox(height: 8),
      FormSubmitButton(
        text: model.buttonText,
        onPressed: model.isButtonEnabled ? _submit : null,
      ),
      TextButton(
        onPressed: model.isLoading ? null : _changeFormType,
        child: Text(model.secondaryButtonText),
      )
    ];
  }

  Widget _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      enabled: model.isLoading == false,
      obscureText: true,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Input Password',
        errorText: model.showPasswordError,
      ),
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );
  }

  Widget _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      enabled: model.isLoading == false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'john_doe@email.com',
        errorText: model.showEmailError,
      ),
      onChanged: widget.bloc.updateEmail,
    );
  }
}

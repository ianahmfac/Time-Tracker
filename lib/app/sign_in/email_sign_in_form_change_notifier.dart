import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/email_sign_in_change_model.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/form_submit_button.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;
  EmailSignInFormChangeNotifier({
    Key? key,
    required this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await model.submit();
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
    model.changeFormType();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
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

  Widget _buildPasswordTextField() {
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
      onChanged: model.updatePassword,
    );
  }

  Widget _buildEmailTextField() {
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
      onChanged: model.updateEmail,
    );
  }
}

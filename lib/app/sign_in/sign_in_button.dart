import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/custom_button.dart';

// * [SignInButton just make its own property based on the CustomButton]
class SignInButton extends CustomButton {
  SignInButton({
    required String text,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}

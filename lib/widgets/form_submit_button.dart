import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/custom_button.dart';

class FormSubmitButton extends CustomButton {
  FormSubmitButton({
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: onPressed,
          height: 44,
        );
}

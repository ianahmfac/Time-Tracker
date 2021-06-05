import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/custom_button.dart';

class SocialSignInButton extends CustomButton {
  SocialSignInButton({
    required String text,
    required String assetName,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog {
  final String titleText;
  final String contentText;
  final String buttonDialogText;
  final String? cancelButtonDialogText;
  PlatformAlertDialog({
    required this.titleText,
    required this.contentText,
    required this.buttonDialogText,
    this.cancelButtonDialogText,
  });

  Future<bool?> show(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            if (cancelButtonDialogText != null)
              CupertinoDialogAction(
                child: Text(cancelButtonDialogText!),
                onPressed: () => Navigator.pop(context, false),
              ),
            CupertinoDialogAction(
              child: Text(buttonDialogText),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
    } else {
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            if (cancelButtonDialogText != null)
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelButtonDialogText!),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(buttonDialogText),
            ),
          ],
        ),
      );
    }
  }
}

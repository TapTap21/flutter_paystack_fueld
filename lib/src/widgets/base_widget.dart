import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_fueld/src/models/checkout_response.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool isProcessing = false;
  String confirmationMessage = 'Do you want to cancel payment?';
  bool alwaysPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow PopScope to handle back navigation
      onPopInvoked: _onWillPop,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context);

  void _onWillPop(bool didPop) async {
    if (!didPop) {
      if (isProcessing) {
        // Block back navigation when processing
        return;
      }

      var returnValue = getPopReturnValue();
      if (alwaysPop ||
          (returnValue != null &&
              (returnValue is CheckoutResponse &&
                  returnValue.status == true))) {
        Navigator.of(context).pop(returnValue);
        return;
      }

      var text = Text(confirmationMessage);

      var dialog = Platform.isIOS
          ? CupertinoAlertDialog(
              content: text,
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('No'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ],
            )
          : AlertDialog(
              content: text,
              actions: <Widget>[
                TextButton(
                    child: const Text('NO'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                TextButton(
                    child: const Text('YES'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    })
              ],
            );

      bool exit = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => dialog,
          ) ??
          false;

      if (exit) {
        Navigator.of(context).pop(returnValue);
      }
    }
  }

  void onCancelPress() async {
    _onWillPop(false);
  }

  getPopReturnValue() {
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastContext {
  ToastContext(BuildContext context, String msg, bool isSuccesses) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: isSuccesses ? Colors.greenAccent : Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSuccesses
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Icon(Icons.error, color: Colors.white),
            SizedBox(
              width: 12.0,
            ),
            Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}

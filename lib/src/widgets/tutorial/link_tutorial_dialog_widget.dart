import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/screens/login/login_screen.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkTutorialDialogWidget {
  void showTutorial(BuildContext context) {
    showAlertDialog(context).then((value) async {
      if (value != null) {}
    });
  }

  Future<Map<String, dynamic>> showAlertDialog(BuildContext context) {
    TextEditingController urlController = new TextEditingController();
    TextEditingController portController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Image.asset('assets/intro/animation1.gif', width: 200.0),
                SizedBox(
                  height: 20,
                ),
                Text("By swiping to the right options appears")
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 2,
                child: Text(
                  "Ok",
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                elevation: 2,
                child: Text(
                  "Don't show again",
                  style: TextStyle(color: secondaryTextColor),
                ),
                onPressed: () {
                  _saveLinkTutorial();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<bool> _saveLinkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'linkTutorial';
    final isSaved = prefs.setBool(key, true);
    return isSaved;
  }


}

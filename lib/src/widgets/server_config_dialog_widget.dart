import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerConfigDialogWidget {
  void saveConfiguration(BuildContext context) {
    showAlertDialog(context).then((value) async {
      if (value != null) {
        final url = value["url"];
        final port = value["port"];
        if (Uri.parse(url).isAbsolute) {
          final result =
              _saveUrl('${url.replaceAll(new RegExp(r"\s+"), "")}:$port');
          result.then((value) {
            if (value) {
              ToastContext(
                  context, "Saved successfully, now you can login", true);
            } else {
              ToastContext(context, "Failed to save", false);
            }
          });
        } else {
          ToastContext(
              context, "Enter valid url like: http://address.com", false);
        }
      }
    });
  }

  Future<Map<String, dynamic>> showAlertDialog(BuildContext context) {
    TextEditingController urlController = new TextEditingController();
    TextEditingController portController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Enter Your Server Address",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
            ),
            content: Row(
              children: <Widget>[
                Expanded(child: buildUrlField(urlController), flex: 2),
                SizedBox(width: 5),
                Expanded(child: buildPortField(portController)),
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 2,
                child: Text(
                  "Save",
                  style: TextStyle(color: secondaryTextColor),
                ),
                onPressed: () {
                  Map<String, dynamic> toMap = new Map<String, dynamic>();
                  toMap["url"] = urlController.text;
                  toMap["port"] =
                      portController.text.isNotEmpty ? portController.text : 80;
                  Navigator.of(context).pop(toMap);
                },
              )
            ],
          );
        });
  }

  Widget buildUrlField(TextEditingController urlController) {
    return TextField(
      controller: urlController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        labelText: "Url",
        hintText: "http://server.com",
      ),
    );
  }

  Widget buildPortField(TextEditingController portController) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: portController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        labelText: "Port",
        hintText: "5000",
      ),
    );
  }

  Future<bool> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'urlAddress';
    final isSaved = prefs.setString(key, url);
    return isSaved;
  }
}

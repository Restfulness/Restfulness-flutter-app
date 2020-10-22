import 'package:flutter/material.dart';
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
              showSnackBar(
                  context, "Saved successfully, know you can login", true);
            } else {
              showSnackBar(context, "Failed to save", true);
            }
          });
        } else {
          showSnackBar(
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
            title: Text("Enter Your Server Address" ,style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue),),
            content: Row(
              children: <Widget>[
                Expanded(child: buildUrlField(urlController), flex: 3),
                SizedBox(width: 5),
                Expanded(child: buildPortField(portController)),
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 2,
                child: Text("Save"),
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
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        border: OutlineInputBorder(),
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
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        border: OutlineInputBorder(),
        labelText: "Port",
        hintText: "5000",
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, bool isSuccess) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Row(
          children: [
            isSuccess
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10.0),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 4)));
  }

  Future<bool> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'urlAddress';
    final isSaved = prefs.setString(key, url);
    return isSaved;
  }
}

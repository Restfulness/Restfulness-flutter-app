import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/screens/login/login_screen.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerConfigDialogWidget {
  void saveConfiguration(BuildContext context , Type screenName) {
    showAlertDialog(context,screenName).then((value) async {
      if (value != null) {
        String url = value["url"];
        final port = value["port"];
        print(url);
        if (url.isNotEmpty) {
          Future<bool> result;
          if (url.contains("https")) {
            result = _saveUrl(
                '${_validateUrl(url.replaceAll(new RegExp(r"\s+"), ""))}');
          } else {
            result = _saveUrl(
                '${_validateUrl(url.replaceAll(new RegExp(r"\s+"), ""))}:$port');
          }
          result.then((value) {
            if (value) {
              ToastContext(
                  context, "Saved successfully", true);
            } else {
              ToastContext(context, "Failed to save", false);
            }
          });
        } else {
          ToastContext(context, "URL can not be empty", false);
        }
      }
    });
  }

  Future<Map<String, dynamic>> showAlertDialog(BuildContext context, Type screenName) {
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
                  "Use demo server",
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () {
                  _saveDemo(true);
                  Map<String, dynamic> toMap = new Map<String, dynamic>();
                  toMap["url"] = "https://api.restfulness.app";
                  toMap["port"] = 443;
                  Navigator.of(context).pop(toMap);

                  goToLoginScreen(context,screenName);
                },
              ),
              MaterialButton(
                elevation: 2,
                child: Text(
                  "Save",
                  style: TextStyle(color: secondaryTextColor),
                ),
                onPressed: () {
                  _saveDemo(false);
                  Map<String, dynamic> toMap = new Map<String, dynamic>();
                  toMap["url"] = urlController.text;
                  toMap["port"] =
                      portController.text.isNotEmpty ? portController.text : 80;
                  Navigator.of(context).pop(toMap);

                  goToLoginScreen(context,screenName);
                },
              ),
            ],
          );
        });
  }

  Widget buildUrlField(TextEditingController urlController) {
    return FutureBuilder(
      future: _readUrl(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == '') {
          return urlField(urlController, "http://server.com");
        }
        String address = snapshot.data;
        Uri myUri = Uri.parse(address);
        urlController.text = myUri.host;
        return urlField(urlController, myUri.host);
      },
    );
  }

  Widget urlField(TextEditingController urlController, String hint) {
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
        hintText: hint,
      ),
    );
  }

  Widget buildPortField(TextEditingController portController) {
    return FutureBuilder(
      future: _readUrl(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == '') {
          return portField(portController, "5000");
        }
        String address = snapshot.data;
        Uri myUri = Uri.parse(address);
        portController.text = myUri.port.toString();
        return portField(portController, myUri.port.toString());
      },
    );
  }

  Widget portField(TextEditingController portController, String hint) {
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
        hintText: hint,
      ),
    );
  }

  Future<bool> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'urlAddress';
    final isSaved = prefs.setString(key, url);
    return isSaved;
  }

  Future<String> _readUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'urlAddress';
    final value = prefs.getString(key) ?? '';
    return value;
  }

  Future<bool> _saveDemo(bool isDemo) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'demo';
    final isSaved = prefs.setBool(key, isDemo);
    return isSaved;
  }

  void goToLoginScreen(BuildContext context, Type screenName){

    if(screenName != LoginScreen ){
      Repository repository = new Repository() ;
      repository.clearUserCache();
      repository.clearLinkCache();
      _redirectToPage(context, LoginScreen());
    }
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
    MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    final bool nav = await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/'));
  }

  _validateUrl(String url) {
    if (url?.startsWith('http://') == true ||
        url?.startsWith('https://') == true) {
      return url;
    } else {
      return 'https://$url';
    }
  }
}

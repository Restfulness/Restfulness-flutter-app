import 'package:flutter/material.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'file:///C:/Users/Farzad/Documents/Projects/GitHub/Restfulness-flutter-app/lib/src/screens/login/login_screen.dart';
import 'package:restfulness/src/widgets/server_config_dialog_widget.dart';

class DrawerWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150.0,
              child:  DrawerHeader(
                child: Text('Menu',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.http),
              title: Text('Server config'),
              onTap: ()  {
                ServerConfigDialogWidget configDialog =
                new ServerConfigDialogWidget();
                 configDialog.saveConfiguration(context);

              },

            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                final repository = new Repository();
                await repository.initializationAuth;
                await repository.clearUserCache();
                _redirectToPage(context, LoginScreen());
              },
            ),
          ],
        ),
      );
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
    MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    final bool nav = await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/'));
    if (nav == true) {
      //TODO: init
    }
  }


}
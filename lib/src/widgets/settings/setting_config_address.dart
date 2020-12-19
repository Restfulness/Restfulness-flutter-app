import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../server_config_dialog_widget.dart';

class SettingConfigAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                "Config server address",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Positioned(
              child: ButtonTheme(
                minWidth: 1,
                height: 1,
                child: MaterialButton(
                    onPressed: () {
                      ServerConfigDialogWidget configDialog =
                      new ServerConfigDialogWidget();
                      configDialog.saveConfiguration(context,this.runtimeType);
                    },
                    elevation: 1,
                    color: primaryLightColor,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "config",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
              ),
              right: 10,
            ),
          ],
        ),
      ),
    );
  }
}

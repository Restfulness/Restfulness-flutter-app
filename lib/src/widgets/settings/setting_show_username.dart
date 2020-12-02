import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/resources/repository.dart';

class SettingShowUsername extends StatelessWidget {
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
                "Username",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Positioned(
              child: buildUsername(),
              right: 15,
              top: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUsername() {
    return FutureBuilder(
      future: getUsername(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('');
        }
        return Center(
          child: Text(
            snapshot.data,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Future<String> getUsername() async {
    final repository = new Repository();
    await repository.initializationAuth;

    final user = await repository.currentUser();
    return user.username;
  }
}

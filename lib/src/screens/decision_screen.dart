import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/resources/repository.dart';

import 'login_screen.dart';
import 'main_screen.dart';

class DecisionScreen extends StatefulWidget {
  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  String _state = 'Welcome';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repository = new Repository();
      await repository.initializationAuth;

      final user = await repository.currentUser();

      if (user == null) {
        _redirectToPage(context, LoginScreen());
      } else {
        repository.clearUserCache();
        final userLogin = await repository.login(user.username, user.password);
        if(userLogin.accessToken.isNotEmpty){
          final bloc = LinksProvider.of(context);
          bloc.fetchLinks();
          _redirectToPage(context, MainScreen());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: buildLoading(),
        ),
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

  Widget buildLoading() {
    return Text(
      _state,
      textAlign: TextAlign.left,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0,color: Colors.blue),
    );
  }
}

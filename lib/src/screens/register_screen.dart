import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/authentication/auth_bloc.dart';
import 'package:restfulness/src/blocs/authentication/auth_provider.dart';

import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
      ),
      body: buildBody(bloc,context),
    );
  }


  buildBody(AuthBloc bloc, BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset("assets/images/restApi.png", width: 120),
            Container(margin: EdgeInsets.only(top: 30.0)),
            buildTitle(),
            Container(margin: EdgeInsets.only(top: 20.0)),
            usernameField(bloc),
            Container(margin: EdgeInsets.only(top: 10.0)),
            passwordField(bloc),
            Container(margin: EdgeInsets.only(top: 20.0)),
            buildSignUpButton(bloc),
            Container(margin: EdgeInsets.only(top: 20.0)),
            buildLoginButton(context,bloc),
          ],
        ),
      ),
    );
  }
  Widget buildTitle() {

    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        "Lets Join To Restfulness",
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0,color: Colors.blue),
      ),
    );
  }

  Widget usernameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.usernameSignUp,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (newValue) {
            bloc.changeUsernameSignUp(newValue);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(),
            labelText: "Username",
            hintText: "example",
            errorText: snapshot.error,
          ),
          autofocus: false,
        );
      },
    );
  }

  Widget passwordField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordSignUp,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePasswordSignUp,
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(),
            labelText: "Password",
            hintText: "strong password",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget buildSignUpButton(AuthBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitButtonSignUp,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: ButtonTheme(
              minWidth: double.infinity,
              height: 45.0,
              child: RaisedButton(
                elevation: 5.0,
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                color: Colors.blue,
                disabledColor: Colors.blueAccent,
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                onPressed: snapshot.hasData
                    ? () {
                  bloc.submitRegister(context);
                }
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          );
        });
  }

  Widget buildLoginButton(BuildContext context,AuthBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonTheme(
        height: 45.0,
        child: FlatButton(
          child: Text("Already registered! Login Me.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              )),
          color: Colors.transparent,
          textColor: Colors.blue,
          onPressed: () {
            _redirectToPage(context, LoginScreen());
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
        MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/login'));
  }
}

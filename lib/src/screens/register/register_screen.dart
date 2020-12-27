import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/authentication/auth_bloc.dart';
import 'package:restfulness/src/blocs/authentication/auth_provider.dart';
import 'package:restfulness/src/screens/register/register_background.dart';

import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: buildBody(bloc, context),
    );
  }

  buildBody(AuthBloc bloc, BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return RegisterBackground(
        child: SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        margin: EdgeInsets.fromLTRB(30.0, 0, 30, 30),
        child: Column(
          children: [
            Image.asset("assets/icons/restApi.png", width: 100),
            Container(margin: EdgeInsets.only(top: 30.0)),
            buildTitle(),
            Container(margin: EdgeInsets.only(top: 30.0)),
            usernameField(bloc),
            Container(margin: EdgeInsets.only(top: 10.0)),
            passwordField(bloc),
            Container(margin: EdgeInsets.only(top: 10.0)),
            buildSignUpButton(bloc),
            Container(margin: EdgeInsets.only(top: 20.0)),
            buildLoginButton(context, bloc),
          ],
        ),
      ),
    ));
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        "Lets Join To Restfulness",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: primaryColor),
      ),
    );
  }

  Widget usernameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailSignUp,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (newValue) {
            bloc.changeEmailSignUp(newValue);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: "Email",
            hintText: "example@email.com",
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
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: "Password",
            hintText: "strong password",
            errorText: snapshot.error,
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: primaryColor,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildSignUpButton(AuthBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitButtonSignUp,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return ButtonTheme(
            minWidth: double.infinity,
            height: 50.0,
            child: RaisedButton(
              elevation: 5.0,
              child: Text(
                "Register",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              color: primaryColor,
              disabledColor: primaryLightColor,
              textColor: Colors.white,
              disabledTextColor: Colors.white,
              onPressed: snapshot.hasData
                  ? () {
                      FocusScope.of(context).unfocus();
                      bloc.submitRegister(context);
                    }
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          );
        });
  }

  Widget buildLoginButton(BuildContext context, AuthBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonTheme(
        height: 45.0,
        child: FlatButton(
          child: RichText(
              text: TextSpan(
            style: TextStyle(
              fontSize: 12.0,
              color: textColor,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: 'Already registered! ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'Login Me',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryLightColor)),
            ],
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/authentication/auth_bloc.dart';
import 'package:restfulness/src/blocs/authentication/auth_provider.dart';
import 'package:restfulness/src/screens/login/login_background.dart';
import 'package:restfulness/src/widgets/server_config_dialog_widget.dart';

import '../../../constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Builder(
          builder: (BuildContext context) {
            return buildBody(bloc, context);
          },
        ),
      ),
    );
  }

  buildBody(AuthBloc bloc, BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return LoginBackground(
        child: SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.only(bottom: bottom),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30.0,0,30,30),
            child: Column(
              children: [
                Container(margin: EdgeInsets.only(top: 60.0)),
                Image.asset("assets/icons/restApi.png", width: 100),
                Container(margin: EdgeInsets.only(top: 30.0)),
                buildTitle(),
                Container(margin: EdgeInsets.only(top: 30.0)),
                usernameField(bloc),
                Container(margin: EdgeInsets.only(top: 10.0)),
                passwordField(bloc),
                Container(margin: EdgeInsets.only(top: 10.0)),
                buildLoginButton(bloc),
                Container(margin: EdgeInsets.only(top: 20.0)),
                signUpAndForgotPassButtons(context, bloc),
              ],
            ),
          ),
          Positioned(
            child: createGearButton(context),
            top: 0,
            right: 5,
          ),
        ],
      ),
    ));
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        "Welcome To Restfulness",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: primaryColor),
      ),
    );
  }

  Widget usernameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.usernameLogin,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (newValue) {
            bloc.changeUsernameLogin(newValue);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
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
      stream: bloc.passwordLogin,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePasswordLogin,
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            labelText: "Password",
            hintText: "password",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }


  Widget buildLoginButton(AuthBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitButtonLogin,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return  ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              child: RaisedButton(
                elevation: 5.0,
                child: Text(
                  "Login",
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
                        bloc.submitLogin(context);
                      }
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            );
        });
  }

  Widget signUpAndForgotPassButtons(BuildContext context ,AuthBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildSignUpButton(context,bloc),
        buildForgotButton()
      ],
    );
  }

  Widget buildForgotButton() {
    return ButtonTheme(
        minWidth: 140.0,
        height: 45.0,
        child: FlatButton(
          child: Text("Forgot Password?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              )),
          color: Colors.transparent,
          textColor: textColor,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
  }

  Widget buildSignUpButton(BuildContext context, AuthBloc bloc) {
    return  ButtonTheme(
        height: 45.0,
        child: FlatButton(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.0,
                color: textColor,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Not a member? ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'Sign up now.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: secondaryTextColor)),
              ],
            ),
          ),
          color: Colors.transparent,
          textColor: textColor,
          onPressed: () {
            Navigator.pushNamed(context, "/register");
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
  }

  Widget createGearButton(BuildContext context) {
    return ButtonTheme(
      minWidth: 1,
      height: 40.0,
      child: FlatButton(
        child: Icon(
          MdiIcons.cogOutline,
          color: primaryColor,
        ),
        shape: CircleBorder(),
        color: Colors.transparent,
        onPressed: () async {
          ServerConfigDialogWidget configDialog =
              new ServerConfigDialogWidget();
          configDialog.saveConfiguration(context);
        },
      ),
    );
  }
}

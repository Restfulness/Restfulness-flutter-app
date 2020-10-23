import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/authentication/auth_bloc.dart';
import 'package:restfulness/src/blocs/authentication/auth_provider.dart';
import 'package:restfulness/src/widgets/server_config_dialog_widget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
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
    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.only(bottom: bottom),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(margin: EdgeInsets.only(top: 60.0)),
                Image.asset("assets/images/restApi.png", width: 120),
                Container(margin: EdgeInsets.only(top: 30.0)),
                buildTitle(),
                Container(margin: EdgeInsets.only(top: 20.0)),
                usernameField(bloc),
                Container(margin: EdgeInsets.only(top: 10.0)),
                passwordField(bloc),
                Container(margin: EdgeInsets.only(top: 20.0)),
                loginAndForgotPassButtons(bloc),
                Container(margin: EdgeInsets.only(top: 20.0)),
                buildSignUpButton(context, bloc),
              ],
            ),
          ),
          Positioned(
            child: createGearButton(context),
            top: 25,
            right: 5,
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        "Welcome To Restfulness",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.blue),
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
      stream: bloc.passwordLogin,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePasswordLogin,
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: OutlineInputBorder(),
            labelText: "Password",
            hintText: "password",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget loginAndForgotPassButtons(AuthBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: buildLoginButton(bloc), flex: 1),
        SizedBox(width: 5),
        Expanded(child: buildForgotButton(), flex: 1),
      ],
    );
  }

  Widget buildLoginButton(AuthBloc bloc) {
    return StreamBuilder(
        stream: bloc.submitButtonLogin,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: 140.0,
              height: 45.0,
              child: RaisedButton(
                elevation: 5.0,
                child: Text(
                  "Login",
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
                        bloc.submitLogin(context);
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

  Widget buildForgotButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonTheme(
        minWidth: 140.0,
        height: 45.0,
        child: FlatButton(
          child: Text("Forgot Password?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              )),
          color: Colors.transparent,
          textColor: Colors.blue,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget buildSignUpButton(BuildContext context, AuthBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonTheme(
        height: 45.0,
        child: FlatButton(
          child: Text("Not a member? Sign up now.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              )),
          color: Colors.transparent,
          textColor: Colors.blue,
          onPressed: () {
            Navigator.pushNamed(context, "/register");
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
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
          color: Colors.blue,
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

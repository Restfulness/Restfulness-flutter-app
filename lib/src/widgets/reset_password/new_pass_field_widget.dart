import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/authentication/auth_bloc.dart';
import 'package:restfulness/src/blocs/authentication/auth_provider.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_bloc.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_provider.dart';

class NewPassFieldWidget extends StatefulWidget {
  final String token;

  const NewPassFieldWidget({
    Key key,
    this.token,
  }) : super(key: key);

  @override
  NewPassFieldWidgetState createState() => NewPassFieldWidgetState();
}

class NewPassFieldWidgetState extends State<NewPassFieldWidget> {
  bool _passwordVisible = false;

  ResetPasswordBloc resetBloc;
  TextEditingController newPassController;

  int _state = 0;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    newPassController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    resetBloc = ResetPasswordProvider.of(context);
    final authBloc = AuthProvider.of(context);
    return Column(
      children: [
        buildDescriptions(),
        passwordField(authBloc),
        Container(margin: EdgeInsets.only(top: 10.0)),
        buildResetButton(),
        Container(margin: EdgeInsets.only(top: 20.0)),
      ],
    );
  }

  Widget buildDescriptions() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      child: Text(
        "Enter new password",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15.0, color: primaryColor),
      ),
    );
  }

  Widget passwordField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordSignUp,
      builder: (context, snapshot) {
        return TextField(
          controller: newPassController,
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

  Widget buildResetButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      child: RaisedButton(
        elevation: 5.0,
        child: setUpButtonState(),
        color: primaryColor,
        disabledColor: primaryLightColor,
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        onPressed: () {
          setState(() {
            if (_state == 0 ) {
              animateButton();
            }
          });
          FocusScope.of(context).unfocus();
          resetBloc.resetPass(widget.token, newPassController.text);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }


  Widget setUpButtonState() {
    if (_state == 0) {
      return Text(
        "Reset",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });
  }
  void stopAnimation(){
    resetBloc.resetResetPassStream();
    setState(() {
      _state = 0;
    });
  }
}

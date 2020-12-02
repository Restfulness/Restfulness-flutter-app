import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_bloc.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_provider.dart';

class EmailFieldWidget extends StatefulWidget {
  EmailFieldWidget({Key key}) : super(key: key);

  @override
  EmailFieldWidgetState createState() => EmailFieldWidgetState();
}

class EmailFieldWidgetState extends State<EmailFieldWidget> {
  ResetPasswordBloc bloc;
  TextEditingController emailController;

  int _state = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    emailController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bloc = ResetPasswordProvider.of(context);
    return Column(
      children: [
        buildDescriptions(),
        emailField(),
        Container(margin: EdgeInsets.only(top: 10.0)),
        buildResetPassButton(bloc),
        Container(margin: EdgeInsets.only(top: 20.0)),
      ],
    );
  }

  Widget buildDescriptions() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      child: Text(
        "Enter your email address to send validation code to your email",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15.0, color: primaryColor),
      ),
    );
  }

  Widget emailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        labelText: "Email",
        hintText: "example@restfulness.com",
      ),
      autofocus: false,
    );
  }

  Widget buildResetPassButton(ResetPasswordBloc bloc) {
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
          bloc.forgotPass(emailController.text);
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
        "Reset password",
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
    bloc.resetForgetPassStream();
    setState(() {
      _state = 0;
    });
  }
}

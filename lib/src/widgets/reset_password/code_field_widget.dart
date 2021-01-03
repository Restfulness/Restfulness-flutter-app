import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_bloc.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_provider.dart';

class CodeFieldWidget extends StatefulWidget {
  final String hashData;

  const CodeFieldWidget({
    Key key,
    this.hashData,
  }) : super(key: key);

  @override
  CodeFieldWidgetState createState() => CodeFieldWidgetState();
}

class CodeFieldWidgetState extends State<CodeFieldWidget> {
  ResetPasswordBloc bloc;
  TextEditingController codeController;

  int _state = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    codeController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bloc = ResetPasswordProvider.of(context);
    return Column(
      children: [
        buildDescriptions(),
        codeField(),
        Container(margin: EdgeInsets.only(top: 10.0)),
        buildSubmitButton(bloc),
        Container(margin: EdgeInsets.only(top: 20.0)),
      ],
    );
  }

  Widget buildDescriptions() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      child: Text(
        "Code sent to your email",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15.0, color: primaryColor),
      ),
    );
  }

  Widget codeField() {
    return TextField(
      controller: codeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        labelText: "Enter code",
        hintText: "xxxxxxxx",
      ),
      autofocus: false,
    );
  }

  Widget buildSubmitButton(ResetPasswordBloc bloc) {
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
          bloc.verifyCode(widget.hashData, int.parse(codeController.text.replaceAll(new RegExp(r"\s+"), "")));
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
        "Submit",
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
    bloc.resetVerifyCodeStream();
    setState(() {
      _state = 0;
    });
  }
}

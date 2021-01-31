import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/authentication/auth_bloc.dart';
import 'package:restfulness/src/blocs/authentication/auth_provider.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_bloc.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_provider.dart';
import 'package:restfulness/src/screens/login/login_screen.dart';
import 'package:restfulness/src/screens/register/register_background.dart';
import 'package:restfulness/src/widgets/reset_password/code_field_widget.dart';
import 'package:restfulness/src/widgets/reset_password/email_field_widget.dart';
import 'package:restfulness/src/widgets/reset_password/new_pass_field_widget.dart';
import 'package:restfulness/src/widgets/toast_context.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final GlobalKey<EmailFieldWidgetState> globalKeyEmailField = GlobalKey();
  final GlobalKey<CodeFieldWidgetState> globalKeyCodeField = GlobalKey();
  final GlobalKey<NewPassFieldWidgetState> globalKeyResetField = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildBody(bloc, context),
    );
  }

  buildBody(AuthBloc bloc, BuildContext context) {
    final bloc = ResetPasswordProvider.of(context);
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
            buildEmailBody(bloc),
            buildLoginButton(context, bloc),
          ],
        ),
      ),
    ));
  }

  Widget buildEmailBody(ResetPasswordBloc bloc) {
    return StreamBuilder(
      stream: bloc.forgot,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastContext(context, snapshot.error, false);
            globalKeyEmailField.currentState.stopAnimation();
          });
        }
        if (!snapshot.hasData || snapshot.data == '') {
          return EmailFieldWidget(
            key: globalKeyEmailField,
          );
        }
        return buildCodeBody(bloc, snapshot.data);
      },
    );
  }

  Widget buildCodeBody(ResetPasswordBloc bloc, String hashData) {
    return StreamBuilder(
      stream: bloc.code,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastContext(context, snapshot.error, false);
            globalKeyCodeField.currentState.stopAnimation();
          });
        }
        if (!snapshot.hasData || snapshot.data == '') {
          return CodeFieldWidget(
            key: globalKeyCodeField,
            hashData: hashData,
          );
        }
        return buildResetBody(bloc, snapshot.data);
      },
    );
  }

  Widget buildResetBody(ResetPasswordBloc bloc, String token) {
    return StreamBuilder(
      stream: bloc.reset,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastContext(context, snapshot.error, false);
            globalKeyResetField.currentState.stopAnimation();
          });
        }
        if (!snapshot.hasData || snapshot.data == '') {
          return NewPassFieldWidget(
            key: globalKeyResetField,
            token: token,
          );
        }

        return Text(
          snapshot.data,
          style: TextStyle(fontSize: 25, color: Colors.green),
        );
      },
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        "Forgot password?",
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: primaryColor),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context, ResetPasswordBloc bloc) {
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
                  text: 'Login Me',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryLightColor)),
            ],
          )),
          color: Colors.transparent,
          textColor: Colors.blue,
          onPressed: () {
            bloc.resetFVR();
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

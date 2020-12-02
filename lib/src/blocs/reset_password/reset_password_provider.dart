import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_bloc.dart';

class ResetPasswordProvider extends InheritedWidget {
  final ResetPasswordBloc bloc = new ResetPasswordBloc();

  ResetPasswordProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ResetPasswordBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ResetPasswordProvider>())
        .bloc;
  }
}

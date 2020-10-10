import 'package:flutter/material.dart';

import 'auth_bloc.dart';

class AuthProvider extends InheritedWidget {
  final AuthBloc bloc = new AuthBloc();

  AuthProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AuthBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthProvider>()).bloc;
  }
}

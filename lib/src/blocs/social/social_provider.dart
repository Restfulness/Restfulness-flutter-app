import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/social/social_bloc.dart';

class SocialProvider extends InheritedWidget {
  final SocialBloc bloc = new SocialBloc();

  SocialProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static SocialBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<SocialProvider>()).bloc;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';

class LinksProvider extends InheritedWidget {
  final LinksBloc bloc = new LinksBloc();

  LinksProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LinksBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LinksProvider>()).bloc;
  }
}

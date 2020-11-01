import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';

class CategoriesProvider extends InheritedWidget {
  final CategoriesBloc bloc = new CategoriesBloc();

  CategoriesProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CategoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CategoriesProvider>())
        .bloc;
  }
}

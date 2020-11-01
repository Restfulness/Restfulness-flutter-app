import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/widgets/category_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CategoriesProvider.of(context);
    return _buildList(bloc);
  }

  Widget _buildList(CategoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.category,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text(snapshot.error),
                  duration: Duration(seconds: 2))));
          return CircularProgressIndicator(
            value: 0,
          );
        }
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            CircularProgressIndicator(value: 0);
            return CategoryCardWidget(
                id: snapshot.data[index].id, name: snapshot.data[index].name);
          },
        );
      },
    );
  }

  void showSnackBar(BuildContext context, String message, bool isSuccess) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Row(
          children: [
            isSuccess
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10.0),
            Flexible(child: Text(message)),
          ],
        ),
        duration: Duration(seconds: 2)));
  }
}

import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/widgets/category_card_widget.dart';

class CategoryWidget extends StatelessWidget {
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
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 6),
          ),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return CategoryCardWidget(
                id: snapshot.data[index].id, name: snapshot.data[index].name);
          },
        )
        ;
      },
    );
  }
}

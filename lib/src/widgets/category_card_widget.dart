import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/screens/category_list_screen.dart';

class CategoryCardWidget extends StatelessWidget {
  final int id;
  final String name;

  CategoryCardWidget({this.id, this.name});

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);

    return InkWell(
      onTap: () => {
        bloc.fetchLinksByCategoryId(id,firstPage,firstPageSize),
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryListScreen(
                  name: name,
                  categoryId: id,
                ))).then((context) {
          bloc.restCategoryList();
        })
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

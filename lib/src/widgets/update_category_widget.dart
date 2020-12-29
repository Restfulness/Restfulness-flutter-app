import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:restfulness/src/widgets/toast_context.dart';

class UpdateCategoryWidget {
  void updateCategory(
      BuildContext context, int id, List<CategoryModel> category) {
    _showAlertDialog(context, category).then((value) async {
      if (value != null) {
        final categories = value["category"];
      //.split(RegExp(r"/[ ,]+/")).toString().replaceAll(',', '')
        Repository repository = new Repository();
        repository.initializationLink;

        var removeComma = categories.replaceAll(',' , ' ');
        List<String> catToList =  removeComma.split(' ').toList();

        catToList.removeWhere((value) => value == ' ' || value == '');

        print(catToList);
        try {
          await repository.updateCategory(catToList, id);
          ToastContext(context, "Category updated successfully", true);
          final linkBloc = LinksProvider.of(context);
          
          linkBloc.updateLink(id);

          // get new categories if we have new one
          final categoriesBloc = CategoriesProvider.of(context);
          categoriesBloc.fetchCategories();
        } catch (e) {
          if (JsonUtils.isValidJSONString(e.toString())) {
            ToastContext(context, json.decode(e.toString())["msg"], false);
          } else {
            ToastContext(context, "Unexpected server error", false);
          }
        }
      }
    });
  }

  Future<Map<String, dynamic>> _showAlertDialog(
      BuildContext context, List<CategoryModel> category) {
    String cat = "";
    category.forEach((element) {
      cat += " ${element.name}";
    });
    TextEditingController categoryController =
        new TextEditingController(text: cat);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Enter category",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                 _buildCategoryField(context,categoryController),
                SizedBox(
                  height: 10,
                ),
                Text('You can add more categories by adding space',style: TextStyle(fontSize: 12,color: Colors.grey),),
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 2,
                child: Text(
                  "Update",
                  style: TextStyle(color: secondaryTextColor),
                ),
                onPressed: () {
                  Map<String, dynamic> toMap = new Map<String, dynamic>();
                  toMap["category"] = categoryController.text;
                  Navigator.of(context).pop(toMap);
                },
              )
            ],
          );
        });
  }

  Widget _buildCategoryField(BuildContext context,TextEditingController urlController) {
    if(urlController.text.contains("untagged")){
      urlController.selection = TextSelection(baseOffset:0, extentOffset:urlController.text.length);
    }

    return TextField(
      autofocus: true,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        Map<String, dynamic> toMap = new Map<String, dynamic>();
        toMap["category"] = urlController.text;
        Navigator.of(context).pop(toMap);
      },
      controller: urlController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        labelText: "Category",
        hintText: "enter category",
      ),
    );
  }
}

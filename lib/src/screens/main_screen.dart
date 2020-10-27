import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'file:///C:/Users/Farzad/Documents/Projects/GitHub/Restfulness-flutter-app/lib/src/builder/link_preview.dart';
import 'package:restfulness/src/widgets/drawer_widget.dart';
import 'package:restfulness/src/widgets/link_preview_widget.dart';
import 'package:restfulness/src/widgets/refresh.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home "),
      ),
      floatingActionButton: new Builder(builder: (BuildContext context) {
        return buildFloatingActionButton(context, bloc);
      }),
      drawer: DrawerWidget(),
      body: buildList(bloc),
    );
  }

  Widget buildList(LinksBloc bloc) {
    return StreamBuilder(
        stream: bloc.links,
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

          return Refresh(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                CircularProgressIndicator(value: 0);
                return LinkPreviewWidget(
                    id: snapshot.data[index].id,
                    url: snapshot.data[index].url,
                    category: snapshot.data[index].categories);
              },
            ),
          );
        });
  }

  Widget buildFloatingActionButton(BuildContext context, LinksBloc bloc) {
    return FloatingActionButton(
      child: Icon(MdiIcons.plusThick),
      onPressed: () => {
        showAlertDialog(context).then((value) async {
          final url = value["url"];
          final tags = value["tags"];

          if (value != null) {
            Repository repository = new Repository();
            await repository.initializationLink;

            try {
              final id = await repository.insertLink(
                  tags.toString().split(' ').toList(), url);
              if (id != null) {
                showSnackBar(context, "Saved successfully", true);
                bloc.fetchLinks();
              }
            } catch (e) {
              if (JsonUtils.isValidJSONString(e.toString())) {
                showSnackBar(context, json.decode(e.toString())["msg"], false);
              } else {
                showSnackBar(context, "Unexpected server error ", false);
              }
            }
          }
        }),
      },
    );
  }

  Future<Map<String, dynamic>> showAlertDialog(BuildContext context) {
    TextEditingController urlController = new TextEditingController();
    TextEditingController tagsController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Your URL"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //position
              mainAxisSize: MainAxisSize.min,
              // wrap content in flutter
              children: <Widget>[
                buildUrlField(urlController),
                Container(margin: EdgeInsets.only(top: 20.0)),
                buildTagField(tagsController),
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 2,
                child: Text("ADD"),
                onPressed: () {
                  Map<String, dynamic> toMap = new Map<String, dynamic>();
                  toMap["url"] = urlController.text;
                  toMap["tags"] = tagsController.text;
                  Navigator.of(context).pop(toMap);
                },
              )
            ],
          );
        });
  }

  Widget buildUrlField(TextEditingController urlController) {
    return TextField(
      controller: urlController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        border: OutlineInputBorder(),
        labelText: "Url",
        hintText: "http://github.com",
      ),
    );
  }

  Widget buildTagField(TextEditingController tagsController) {
    return TextField(
      controller: tagsController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        border: OutlineInputBorder(),
        labelText: "Categories",
        hintText: "programming developing",
      ),
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

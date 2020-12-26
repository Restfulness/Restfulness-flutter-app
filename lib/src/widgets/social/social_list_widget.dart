import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/social/social_bloc.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/models/social_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import 'social_user_widget.dart';

class SocialListWidget extends StatefulWidget {
  const SocialListWidget({Key key}) : super(key: key);

  @override
  SocialListWidgetState createState() => SocialListWidgetState();
}

class SocialListWidgetState extends State<SocialListWidget> {
  List<dynamic> _list = new List<dynamic>();

  ScrollController _controller;

  SocialBloc socialBloc;

  int page;
  int pageSize;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    this.page = firstPage;
    this.pageSize = firstPageSize;
  }

  void setList(List<dynamic> list) {
    setState(() {
      _list = list;
    });
    print(_list);
  }

  @override
  Widget build(BuildContext context) {
    socialBloc = SocialProvider.of(context);

    return Column(
      children: [
        Expanded(
          child: buildList(),
          flex: 12,
        ),
        Expanded(
          child: SizedBox(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget buildList() {
    return ListView.builder(
      controller: _controller,
      itemCount: _list.length,
      itemBuilder: (context, int index) {
        SocialModel user = _list[index];

        return SocialUserWidget(
          userId: user.userId,
          username: user.username,
          totalLinks: user.totalLinks,
          lastUpdate: user.lastUpdate,
        );
      },
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page += 1;
      });
      _readPickedDate().then((value) {
        if (value == '') {
          socialBloc.fetchSocial(page: page, pageSize: pageSize);
        } else {
          socialBloc.fetchSocial(
              date: DateTime.parse(value), page: page, pageSize: pageSize);
        }
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  Future<String> _readPickedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'pickedDate';
    final dateString = prefs.getString(key);
    if (dateString != null) {
      return dateString;
    }
    return '';
  }
}

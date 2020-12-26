import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/social/social_bloc.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/widgets/social/social_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final GlobalKey<SocialListWidgetState> _keySocialList = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final socialBloc = SocialProvider.of(context);
    _saveTime();
    return buildBody(socialBloc);
  }

  Widget buildBody(SocialBloc bloc) {

    return StreamBuilder(
      stream: bloc.social,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SocialListWidget(
            key: _keySocialList,
          );
        }

        _keySocialList.currentState.setList(snapshot.data);
        return SocialListWidget(
          key: _keySocialList,
        );
      },
    );
  }

  Future<bool> _saveTime() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lastSeen';
    final isSaved = prefs.setString(key, DateTime.now().toString());
    return isSaved;
  }

}

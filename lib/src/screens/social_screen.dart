import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/blocs/social/social_bloc.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/models/social_model.dart';
import 'package:restfulness/src/widgets/social_user_list_widget.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    final socialBloc = SocialProvider.of(context);

    return buildBody(socialBloc);
  }

  Widget buildBody(SocialBloc bloc) {
    return StreamBuilder(
      stream: bloc.social,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            SocialModel user = snapshot.data[index];

            return SocialUserListWidget(
              userId: user.userId,
              username: user.username,
              totalLinks: user.totalLinks,
              lastUpdate: user.lastUpdate,
            );
          },
        );
      },
    );
  }
}

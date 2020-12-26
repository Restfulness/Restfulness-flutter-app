import 'dart:convert';

import 'package:restfulness/src/models/social_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';

class SocialBloc {
  final _repository = new Repository();
  final _social = BehaviorSubject<List<SocialModel>>();

  Observable<List<SocialModel>> get social => _social.stream;

  List<SocialModel> savedSocialListCard = new List();

  bool isSocialHasData = false;

  DateTime saveDate ;

  fetchSocial({DateTime date, int page , int pageSize }) async {

    try {
      final res = await _repository.social(date ,page,pageSize);

      res.forEach((element) {
        if ((savedSocialListCard.singleWhere((user) => user.userId == element.userId,
            orElse: () => null)) ==
            null) {

          savedSocialListCard.add(element);
        }
      });
      isSocialHasData = true;
      _social.sink.add(savedSocialListCard);
    } catch (e) {
      isSocialHasData = false;
      if (JsonUtils.isValidJSONString(e.toString())) {
        _social.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _social.sink.addError("Unexpected server error");
      }
    }
  }

  resetSocial(){
    savedSocialListCard = [];
    _social.sink.add(savedSocialListCard);
  }

  dispose() {
    _social.close();
  }
}

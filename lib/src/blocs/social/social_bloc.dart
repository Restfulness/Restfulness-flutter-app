import 'dart:convert';

import 'package:restfulness/src/models/social_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';

class SocialBloc {
  final _repository = new Repository();
  final _social = BehaviorSubject<List<SocialModel>>();

  Observable<List<SocialModel>> get social => _social.stream;

  fetchSocial(DateTime date) async {
    try {
      final res = await _repository.social(date);
      _social.sink.add(res);
    } catch (e) {

      if (JsonUtils.isValidJSONString(e.toString())) {
        _social.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _social.sink.addError("Unexpected server error");
      }
    }
  }

  dispose() {
    _social.close();
  }
}

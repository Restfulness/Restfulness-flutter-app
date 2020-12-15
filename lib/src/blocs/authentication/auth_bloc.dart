import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/screens/main_screen.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_validator.dart';

class AuthBloc extends Object with AuthValidator {
  final _repository = new Repository();

  final _usernameLogin = BehaviorSubject<String>();
  final _passwordLogin = BehaviorSubject<String>();

  final _usernameSignUp = BehaviorSubject<String>();
  final _passwordSignUp = BehaviorSubject<String>();

  // Stream
  Observable<String> get usernameLogin => _usernameLogin.stream;

  Observable<String> get passwordLogin => _passwordLogin.stream;

  Observable<bool> get submitButtonLogin =>
      Observable.combineLatest2(usernameLogin, passwordLogin, (e, p) => true);

  Observable<String> get usernameSignUp =>
      _usernameSignUp.stream.transform(validUsername);

  Observable<String> get passwordSignUp =>
      _passwordSignUp.stream.transform(validPassword);

  Observable<bool> get submitButtonSignUp =>
      Observable.combineLatest2(usernameSignUp, passwordSignUp, (e, p) => true);

  // Sink
  Function(String) get changeUsernameLogin => _usernameLogin.sink.add;

  Function(String) get changePasswordLogin => _passwordLogin.sink.add;

  Function(String) get changeUsernameSignUp => _usernameSignUp.sink.add;

  Function(String) get changePasswordSignUp => _passwordSignUp.sink.add;

  submitLogin(BuildContext context) async {
    final validUsername = _usernameLogin.value.toLowerCase();
    final validPassword = _passwordLogin.value;

    /// login
    Repository user = new Repository();
    await user.initializationAuth;

    try {
      final response = await user.login(validUsername, validPassword);
      if (response.accessToken.isNotEmpty) {
        goToMainScreen(context);
      }
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        ToastContext(context, json.decode(e.toString())["msg"], false);
      } else {
        ToastContext(context, "Unexpected server error ", false);
      }
    }
  }

  submitRegister(BuildContext context) async {
    final validUsername = _usernameSignUp.value.toLowerCase();
    final validPassword = _passwordSignUp.value;

    /// Sign-up  TODO refactor signUp after Restfulness api changed. because we need first register and then use login method
    AuthorizationApiProvider userSignUp = new AuthorizationApiProvider();

    try {
      final response = await userSignUp.signUp(validUsername, validPassword);
      if (response.username.isNotEmpty) {
        Repository user = new Repository();
        await user.initializationAuth;

        final response = await user.login(validUsername, validPassword);
        if (response.accessToken.isNotEmpty) {
          goToMainScreen(context);
        }
      }
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        ToastContext(context, json.decode(e.toString())["msg"], false);
      } else {
        ToastContext(context, "Unexpected server error ", false);
      }
    }
  }

  void goToMainScreen(BuildContext context) {
    // TODO goToMainScreen need a separate class we use this method here a and in decision_screen
    final linkBloc = LinksProvider.of(context);
    final categoriesBloc = CategoriesProvider.of(context);
    final socialBloc = SocialProvider.of(context);


    linkBloc.fetchLinks();
    categoriesBloc.fetchCategories();

    _readTime().then((value) {
      if (value.isEmpty) {
        socialBloc.fetchSocial(
            DateTime.now().subtract(Duration(days: 7))); // last week
      } else {
        DateTime date = DateTime.parse(value);
        socialBloc.fetchSocial(DateTime.now().subtract(Duration(days: 7)));
      }
    });

    // TODO refactor after we have all users profile info in login response
    _repository.fetchPublicLinksSetting().then((value) {
      _savePublicSwitch(value);
    });

    _redirectToPage(context, MainScreen());
  }

  Future<String> _readTime() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lastSeen';
    final value = prefs.getString(key) ?? '';
    return value;
  }

  Future<bool> _savePublicSwitch(bool preview) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'publicLinks';
    final isSaved = prefs.setBool(key, preview);
    return isSaved;
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
        MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/login'));
  }

  dispose() {
    _usernameLogin.close();
    _passwordLogin.close();
    _usernameSignUp.close();
    _passwordSignUp.close();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';

class SocialDatePicker {

  static pickTime(BuildContext context) {

    final socialBloc = SocialProvider.of(context);

    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            doneStyle: TextStyle(color: primaryColor, fontSize: 16)),
        showTitleActions: true,
        minTime: DateTime(2020, 1, 1),
        maxTime: DateTime.now(), onChanged: (date) {
    }, onConfirm: (date) {
          socialBloc.fetchSocial(date);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialDatePicker {
  const SocialDatePicker({this.onDateSelect});

  final PickerCallback onDateSelect;

  pickTime(BuildContext context) async {
    final socialBloc = SocialProvider.of(context);

    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      onDateSelect(true);
      _savePickedDate(picked);
      socialBloc.resetSocial();
      socialBloc.fetchSocial(
          date: picked, page: firstPage, pageSize: firstPageSize);
      print(picked);
    }
  }

  Future<bool> _savePickedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'pickedDate';
    final isSaved = prefs.setString(key, date.toString());
    return isSaved;
  }
}

typedef PickerCallback = void Function(bool done);

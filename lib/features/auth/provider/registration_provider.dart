import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/auth/data/user_model.dart';

import '../services/auth_services.dart';

final newUserProvider = StateNotifierProvider<NewUserProvider, UserModel>(
    (ref) => NewUserProvider());

class NewUserProvider extends StateNotifier<UserModel> {
  NewUserProvider() : super(UserModel.empty);

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void register(BuildContext context, WidgetRef ref) async {
    CustomDialogs.loading(message: 'Registering...');
    var (user, message) = await AuthServices.signUp(state);
    CustomDialogs.dismiss();
    if (user != null) {
      CustomDialogs.showDialog(message: message,type:  DialogType.success);
      //pop the registration page
      Navigator.pop(context);
    } else {
      CustomDialogs.showDialog(message: message,type:  DialogType.error);
    }
  }
}

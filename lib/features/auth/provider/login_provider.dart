import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/navigations.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/home/views/home_page.dart';

import '../services/auth_services.dart';
import 'user_provider.dart';

class LoginModel {
  String email;
  String password;
  LoginModel({
    required this.email,
    required this.password,
  });

  LoginModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'password': password});

    return result;
  }
}

final loginModelProvider =
    StateNotifierProvider<LoginAction, LoginModel>((ref) {
  return LoginAction();
});

class LoginAction extends StateNotifier<LoginModel> {
  LoginAction() : super(LoginModel(email: '', password: ''));

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void reset() {
    state = LoginModel(email: '', password: '');
  }

  void login(WidgetRef ref,BuildContext context) async {
    CustomDialogs.loading(message: 'Logging in...');
    var (user, message) =
        await AuthServices.signIn(state.email.trim().replaceAll(' ', ''), state.password);
    if (user != null) {
      ref.read(userProvider.notifier).setUser(user);
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: message, type: DialogType.success);
      //navigate to home page
      navigateAndReplace(context, const HomePage());
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(message: message, type: DialogType.error);
    }
  }
}

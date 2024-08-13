import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/auth/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_model.dart';

final userFutureProvider = FutureProvider<UserModel?>(
  (ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    if (id == null) {
      return null;
    }
    var user = await AuthServices.getUser(userId: id);
    if (user == null) {
      return null;
    }
    ref.read(userProvider.notifier).setUser(user);
    return user;
  },
);

final userProvider = StateNotifierProvider<UserAction, UserModel>((ref) {
  return UserAction();
});

class UserAction extends StateNotifier<UserModel> {
  UserAction() : super(UserModel.empty);

  void setUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.id);
    state = user;
  }

  void reset() {
    state = UserModel.empty;
  }

  void logout() async {
    await AuthServices.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  void setName(String? value) {
    state = state.copyWith(name: value!);
  }

  void setEmail(String? value) {
    state = state.copyWith(email: value!);
  }

  void setPhone(String? value) {
    state = state.copyWith(phoneNumber: value!);
  }

  void update(WidgetRef ref) async {
    CustomDialogs.loading(message: 'Updating...');
    var image = ref.watch(profileImage);
    if(image != null){
      final imageUrl = await AuthServices.uploadImage(image: image,id:  state.id);
      state = state.copyWith(photoUrl: imageUrl);
      ref.read(profileImage.notifier).state = null;
    }
    final result = await AuthServices.updateUser(user: state);
    CustomDialogs.dismiss();
    if (result) {
      CustomDialogs.toast(
          message: 'User updated successfully', type: DialogType.success);
    } else {
      CustomDialogs.toast(message: 'An error occurred', type: DialogType.error);
    }
  }
}

final profileImage = StateProvider<Uint8List?>((ref) => null);

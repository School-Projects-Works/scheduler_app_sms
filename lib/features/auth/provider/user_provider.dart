import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if(user == null){
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

  void setUser(UserModel user) async{
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
}

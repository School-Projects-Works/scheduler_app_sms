import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scheduler_app_sms/features/auth/services/auth_services.dart';

import '../../features/auth/data/user_model.dart';

final usersStream = StreamProvider.autoDispose<List<UserModel>>((ref) async*{
  var data = AuthServices.streamUsers();
  await for (var item in data) {
    ref.read(usersFilterProvider.notifier).set(item);
    yield item;
  }
});

class UsersFilter {
  List<UserModel> items;
  List<UserModel> filter;
  UsersFilter({
    required this.items,
    required this.filter,
  });

  UsersFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filter,
  }) {
    return UsersFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}


final usersFilterProvider = StateNotifierProvider<UsersList, UsersFilter>((ref) {
  return UsersList();
});

class UsersList extends StateNotifier<UsersFilter> {
  UsersList() : super(UsersFilter(items: [], filter: []));

void set(List<UserModel> items) {
    state = state.copyWith(items: items, filter: items);
  }
  void filterUsers(String value) {
    var filter = state.items.where((element) {
      return element.name.toLowerCase().contains(value.toLowerCase())||
          element.email.toLowerCase().contains(value.toLowerCase());
    }).toList();
    state = state.copyWith(filter: filter);
  }
}
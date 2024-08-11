import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';
import 'package:scheduler_app_sms/features/task/services/task_services.dart';
import '../../auth/provider/user_provider.dart';

final taskStreamProvider =
    StreamProvider.autoDispose<List<TaskModel>>((ref) async* {
  var user = ref.watch(userProvider);
  var data = TaskServices.taskStream(userId: user.id);
  await for (var tasks in data) {
    ref.read(taskFilterProvider.notifier).setItem(tasks);
    yield tasks;
  }
});

class TaskFilter {
  List<TaskModel> item;
  List<TaskModel> filter;
  List<TaskModel> todaysTask;
  List
  TaskFilter({required this.item, required this.filter});
  //copyWith

  TaskFilter copyWith({
    List<TaskModel>? item,
    List<TaskModel>? filter,
    
  }) {
    return TaskFilter(
      item: item ?? this.item,
      filter: filter ?? this.filter,
    );
  }
}

final taskFilterProvider =
    StateNotifierProvider<TaskFilterProvider, TaskFilter>((ref) {
  return TaskFilterProvider();
});

class TaskFilterProvider extends StateNotifier<TaskFilter> {
  TaskFilterProvider() : super(TaskFilter(item: [], filter: []));

  void setItem(List<TaskModel> item) {
    state = state.copyWith(item: item, filter: item);
  }

  void filterTask(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.item);
    } else {
      state = state.copyWith(
          filter: state.item
              .where((task) =>
                  task.title.toLowerCase().contains(query.toLowerCase()))
              .toList());
    }
  }
}

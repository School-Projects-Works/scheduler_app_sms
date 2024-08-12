import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scheduler_app_sms/features/task/data/task_model.dart';
import 'package:scheduler_app_sms/features/task/services/task_services.dart';

import '../../auth/provider/user_provider.dart';
import '../services/functions.dart';

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
  List<TaskModel> tomorrowTask;
  List<TaskModel> thisWeekTask;
  TaskModel? dueTask;
  TaskFilter({
    required this.item,
    required this.filter,
    required this.todaysTask,
    required this.tomorrowTask,
    required this.thisWeekTask,
    this.dueTask,
  });
  //copyWith

  TaskFilter copyWith({
    List<TaskModel>? item,
    List<TaskModel>? filter,
    List<TaskModel>? todaysTask,
    List<TaskModel>? tomorrowTask,
    List<TaskModel>? thisWeekTask,
    TaskModel? dueTask,
  }) {
    return TaskFilter(
      item: item ?? this.item,
      filter: filter ?? this.filter,
      todaysTask: todaysTask ?? this.todaysTask,
      tomorrowTask: tomorrowTask ?? this.tomorrowTask,
      thisWeekTask: thisWeekTask ?? this.thisWeekTask,
      dueTask: dueTask ?? this.dueTask,
    );
  }

  static TaskFilter empty = TaskFilter(
      item: [], filter: [], todaysTask: [], tomorrowTask: [], thisWeekTask: []);
}

final taskFilterProvider =
    StateNotifierProvider<TaskFilterProvider, TaskFilter>((ref) {
  return TaskFilterProvider();
});

class TaskFilterProvider extends StateNotifier<TaskFilter> {
  TaskFilterProvider() : super(TaskFilter.empty);

  void setItem(List<TaskModel> item) {
    state = state.copyWith(item: item, filter: item);
    var today = DateTime.now();
    var tomorrow = DateTime.now().add(Duration(days: 1));
    var thisWeek = DateTime.now().add(Duration(days: 7));
    List<TaskModel> todaysTask = item.where((task) {
      var taskDate = DateTime.fromMillisecondsSinceEpoch(task.date);
      return taskDate.day == today.day &&
          taskDate.month == today.month &&
          taskDate.year == today.year;
    }).toList();
    List<TaskModel> tomorrowTask = item.where((task) {
      var taskDate = DateTime.fromMillisecondsSinceEpoch(task.date);
      return taskDate.day == tomorrow.day &&
          taskDate.month == tomorrow.month &&
          taskDate.year == tomorrow.year;
    }).toList();

    List<TaskModel> thisWeekTask = item.where((task) {
      var taskDate = DateTime.fromMillisecondsSinceEpoch(task.date);
      return taskDate.isAfter(today) && taskDate.isBefore(thisWeek);
    }).toList();

    TaskModel dueTask = mostDueTask(item);

    state = state.copyWith(
        todaysTask: todaysTask,
        tomorrowTask: tomorrowTask,
        thisWeekTask: thisWeekTask,
        dueTask: dueTask);
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

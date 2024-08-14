import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/sms_function.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/auth/data/user_model.dart';

import 'package:scheduler_app_sms/features/task/data/task_model.dart';
import 'package:scheduler_app_sms/features/task/services/task_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setItem(List<TaskModel> item) async {
   
    state = state.copyWith(item: item, filter: item);
    var today = DateTime.now();
    var tomorrow = DateTime.now().add(const Duration(days: 1));
    var thisWeek = DateTime.now().add(const Duration(days: 7));
    item.sort((a, b) => a.createdAt.compareTo(b.createdAt));
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

  void deleteTask(String id) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'deleting task..');
    var results = await TaskServices.deleteTask(id);
    if (results) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Task deleted successfully', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Task deletion failed', type: DialogType.error);
    }
  }

  void updateTask(TaskModel copyWith) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'updating task..');
    var results = await TaskServices.updateTask(copyWith);
    if (results) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Task updated successfully', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Task update failed', type: DialogType.error);
    }
  }
}


void sendMessageOnTask(List<TaskModel> items,UserModel user)async{
   List<TaskModel> toBeNotified = items.where((task) {
      var taskDate = isTimeDue(task.time, task.date);
      var isNotCompleted =
          task.status != 'completed' || task.status != 'ongoing';
      var past = isPast(task.time, task.date);
      var isTime = isExactTime(task.time, task.date);
      return (taskDate || past || isTime) && isNotCompleted;
    }).toList();
    List<TaskModel> frequentMessage = items.where((task) {
    var taskDate = isTimeDue(task.time, task.date);
    var isNotCompleted = task.status != 'completed' ||
        task.status != 'accepted' ||
        task.status != 'pending';
    var isTime = isExactTime(task.time, task.date);
    return (taskDate || isTime) && isNotCompleted;
  }).toList();
  if (frequentMessage.isEmpty) {
    var message =
        "Your following task needs your attention\n${toBeNotified.map((e) => '${e.title} : ${formatDateTime(e.date, e.time)}').join('\n')}";
    await sendMessage(user.phoneNumber, message);
  }
    if (toBeNotified.isNotEmpty) {
      var ids = toBeNotified.map((e) => e.id).toList().join(',');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var stored = prefs.getString('appointments') ?? '';
      if (stored != ids) {
        var message =
            "Your following task needs your attention\n${toBeNotified.map((e) => '${e.title} : ${formatDateTime(e.date, e.time)}').join('\n')}";
        await sendMessage(user.phoneNumber, message);
        prefs.setString('appointments', ids);
      }
    }
}
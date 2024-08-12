// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/auth/provider/user_provider.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';
import 'package:scheduler_app_sms/features/task/provider/task_provider.dart';
import 'package:scheduler_app_sms/features/task/services/task_services.dart';

final newTaskProvider = StateNotifierProvider<NewTaskProvider, TaskModel>(
    (ref) => NewTaskProvider());

class NewTaskProvider extends StateNotifier<TaskModel> {
  NewTaskProvider() : super(TaskModel.empty());

  void setTaskTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setTaskDescription(String taskDescription) {
    state = state.copyWith(description: taskDescription);
  }

  void setTaskDate(DateTime taskDate) {
    state = state.copyWith(date: taskDate.millisecondsSinceEpoch);
  }

  void setTaskTime(DateTime time) {
    state = state.copyWith(time: time.millisecondsSinceEpoch);
  }

  void setTaskType(String type) {
    state = state.copyWith(type: type);
  }

  void setReminder(bool reminder) {
    state = state.copyWith(notifierMe: reminder);
  }

  void saveTask(BuildContext context, WidgetRef ref) async {
    CustomDialogs.loading(message: 'creating task..');
    var user = ref.watch(userProvider);
    state = state.copyWith(
        userId: user.id,
        status: 'pending',
        id: TaskServices.generateId(),
        createdAt: DateTime.now().millisecondsSinceEpoch);
    var tasks = ref.watch(taskFilterProvider).item;
    //check if task is already created
    var isTaskExist = tasks.any((element) =>
        element.title == state.title &&
        element.date == state.date &&
        element.status != 'completed' &&
        element.time == state.time);
    if (isTaskExist) {
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
          message: 'Task already exist', type: DialogType.error);
    } else {
      var results = await TaskServices.addTask(state);
      if (results) {
        CustomDialogs.dismiss();
        CustomDialogs.toast(
            message: 'Task created successfully', type: DialogType.success);
        //pop model
        Navigator.pop(context);
      } else {
        CustomDialogs.dismiss();
        CustomDialogs.toast(
            message: 'Task creation failed', type: DialogType.error);
      }
    }
  }
}

final editTaskProvider =
    StateNotifierProvider.autoDispose<EditTaskProvider, TaskModel>(
        (ref) => EditTaskProvider());

class EditTaskProvider extends StateNotifier<TaskModel> {
  EditTaskProvider() : super(TaskModel.empty());

  void setTask(TaskModel task) {
    state = task;
  }

  void setTaskTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setTaskDescription(String taskDescription) {
    state = state.copyWith(description: taskDescription);
  }

  void setTaskDate(DateTime taskDate) {
    state = state.copyWith(date: taskDate.millisecondsSinceEpoch);
  }

  void setTaskTime(DateTime time) {
    state = state.copyWith(time: time.millisecondsSinceEpoch);
  }

  void setTaskType(String type) {
    state = state.copyWith(type: type);
  }

  void setReminder(bool reminder) {
    state = state.copyWith(notifierMe: reminder);
  }

  void updateTask(BuildContext context, WidgetRef ref) async {
    CustomDialogs.loading(message: 'updating task..');
    var results = await TaskServices.updateTask(state);
    if (results) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Task updated successfully', type: DialogType.success);
      //pop model
      Navigator.pop(context);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Task update failed', type: DialogType.error);
    }
  }
}

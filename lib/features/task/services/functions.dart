import 'package:intl/intl.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';

TaskModel mostDueTask(List<TaskModel> tasks) {
  // check wich task is most due
  //the one whose date and time is closer to the current date and time
  tasks.sort((a, b) => a.date.compareTo(b.date));
  var mostDueTask = tasks[0];
  for (var task in tasks) {
    if (task.date == mostDueTask.date) {
      if (task.time < mostDueTask.time) {
        mostDueTask = task;
      }
    } else if (task.date < mostDueTask.date) {
      mostDueTask = task;
    }
  }
  return mostDueTask;
}

String formatDate(int date) {
  return DateFormat('EEE dd,MMM,yy')
      .format(DateTime.fromMillisecondsSinceEpoch(date));
}

String formatTime(int time) {
  return DateFormat('hh:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(time));
}

String formatDateTime(int date, int time) {
  return '${formatDate(date)} ${formatTime(time)}';
}

bool isTimeDue(int time, int date) {
  var now = DateTime.now().add(const Duration(minutes: 20));
  var taskTime = DateTime.fromMillisecondsSinceEpoch(time);
  var taskDate = DateTime.fromMillisecondsSinceEpoch(date);
  if (taskDate.isAtSameMomentAs(now)) {
    if (taskTime.isBefore(now)) {
      return true;
    }
  }
  return false;
}

bool isExactTime(int time, int date) {
  var now = DateTime.now();
  var taskTime = DateTime.fromMillisecondsSinceEpoch(time);
  var taskDate = DateTime.fromMillisecondsSinceEpoch(date);
  if (taskDate.isAtSameMomentAs(now)) {
    if (taskTime.isAtSameMomentAs(now)) {
      return true;
    }
  }
  return false;
}

bool isPast (int time, int date){
  var now = DateTime.now();
  var taskTime = DateTime.fromMillisecondsSinceEpoch(time);
  var taskDate = DateTime.fromMillisecondsSinceEpoch(date);
  if (taskDate.isBefore(now)) {
    return true;
  } else if (taskDate.isAtSameMomentAs(now)) {
    if (taskTime.isBefore(now)) {
      return true;
    }
  }
  return false;
}

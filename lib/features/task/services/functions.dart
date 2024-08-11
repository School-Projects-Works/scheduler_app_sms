import 'package:intl/intl.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';

TaskModel mostDueTask(List<TaskModel> tasks){
  // check wich task is most due
  //the one whose date and time is closer to the current date and time
  tasks.sort((a,b) => a.date.compareTo(b.date));
  var mostDueTask = tasks[0];
  for (var task in tasks) {
    if(task.date == mostDueTask.date){
      if(task.time < mostDueTask.time){
        mostDueTask = task;
      }
    }else if(task.date < mostDueTask.date){
      mostDueTask = task;
    }
  }
  return mostDueTask;
}

String formatDate(int date){
  return DateFormat('EEE dd,MMM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(date));
}

String formatTime(int time){
  return DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(time));
}

String formatDateTime(int date, int time){
  return '${formatDate(date)} ${formatTime(time)}';
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/features/task/provider/task_provider.dart';

import '../../../utils/app_colors.dart';
import '../components/task_item.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    var taskList = ref.watch(taskFilterProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
            child: const Text(
              'Today',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.textSubHeader),
            ),
          ),
          if (taskList.todaysTask.isEmpty)
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 15),
              child: const Text(
                'No task for today',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: CustomColors.textSubHeader),
              ),
            ),
          if (taskList.todaysTask.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.todaysTask.length,
              itemBuilder: (context, index) {
                var task = taskList.todaysTask.toList()[index];
                return TaskItem(
                  task: task,
                );
              },
            ),
          Container(
            margin: const EdgeInsets.only(
              top: 15,
              left: 20,
              bottom: 15,
            ),
            child: const Text(
              'Tomorrow',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.textSubHeader),
            ),
          ),
          if (taskList.tomorrowTask.isEmpty)
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 15),
              child: const Text(
                'No task for tomorrow',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: CustomColors.textSubHeader),
              ),
            ),
          if (taskList.tomorrowTask.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.tomorrowTask.length,
              itemBuilder: (context, index) {
                var task = taskList.tomorrowTask.toList()[index];
                return TaskItem(
                  task: task,
                );
              },
            ),
          Container(
            margin: const EdgeInsets.only(
              top: 15,
              left: 20,
              bottom: 15,
            ),
            child: const Text(
              'This Week',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.textSubHeader),
            ),
          ),
          if (taskList.thisWeekTask.isEmpty)
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 15),
              child: const Text(
                'No task for this week',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: CustomColors.textSubHeader),
              ),
            ),
          if (taskList.thisWeekTask.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.thisWeekTask.length,
              itemBuilder: (context, index) {
                var task = taskList.thisWeekTask[index];
                return TaskItem(
                  showDate: true,
                  task: task,
                );
              },
            ),
        ],
      ),
    );
  }
}

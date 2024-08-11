import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/features/task/provider/task_provider.dart';

import '../../../utils/app_colors.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    var taskList = ref.watch(taskFilterProvider);
    return Column(
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
      ],
    );
  }
}

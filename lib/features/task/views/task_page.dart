import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_input.dart';
import 'package:scheduler_app_sms/features/task/provider/task_provider.dart';
import '../../home/components/task_item.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  @override
  Widget build(BuildContext context) {
    var taskList = ref.watch(taskFilterProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextFields(
              hintText: 'search task',
              onChanged: (value) {
                ref.read(taskFilterProvider.notifier).filterTask(value);
              },
              suffixIcon: const Icon(Icons.search),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.filter.length,
              itemBuilder: (context, index) {
                var task = taskList.filter[index];
                return TaskItem(
                  task: task,
                  showDate: true,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

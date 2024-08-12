import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';
import 'package:scheduler_app_sms/features/task/provider/task_provider.dart';
import 'package:scheduler_app_sms/features/task/services/functions.dart';

import '../provider/new_task_provider.dart';
import '../views/edit_task.dart';

class TaskItem extends ConsumerWidget {
   TaskItem({super.key, required this.task});
  final TaskModel task;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          if (task.status == 'pending' || task.status == 'ongoing')
            SlidableAction(
              onPressed: (context) {
                CustomDialogs.showDialog(
                    message:
                        'Are you sure you want to mark this task as completed?',
                    type: DialogType.warning,
                    secondBtnText: 'Complete',
                    onConfirm: () {
                      ref
                          .read(taskFilterProvider.notifier)
                          .updateTask(task.copyWith(status: 'completed'));
                    });
              },
              backgroundColor: const Color.fromARGB(255, 18, 232, 43),
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Done',
            ),
          if (task.status == 'pending')
            SlidableAction(
              onPressed: (context) {
                CustomDialogs.showDialog(
                    message:
                        'Are you sure you want to mark this task as ongoing?',
                    type: DialogType.warning,
                    secondBtnText: 'Ongoing',
                    onConfirm: () {
                      ref
                          .read(taskFilterProvider.notifier)
                          .updateTask(task.copyWith(status: 'ongoing'));
                    });
              },
              backgroundColor: const Color.fromARGB(255, 229, 226, 39),
              foregroundColor: Colors.white,
              icon: Icons.play_arrow,
              label: 'Ongoing',
            ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (task.status != 'completed')
            SlidableAction(
              // An action can be bigger than the others.
              flex: 1,
              onPressed: (context) {
                ref.read(editTaskProvider.notifier).setTask(task);
                editBottomSheet(
                    context,ref, formKey
                );
              },
              backgroundColor: const Color.fromARGB(255, 54, 138, 217),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          SlidableAction(
            onPressed: (context) {
              CustomDialogs.showDialog(
                  message: 'Are you sure you want to delete this task?',
                  type: DialogType.warning,
                  secondBtnText: 'Delete',
                  onConfirm: () {
                    ref.read(taskFilterProvider.notifier).deleteTask(task.id);
                  });
            },
            backgroundColor: const Color.fromARGB(255, 207, 3, 13),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              width: 5,
              color: task.status == 'pending'
                  ? Colors.black
                  : task.status == 'completed'
                      ? Colors.green
                      : Colors.red,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(3, 5), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(formatTime(task.time),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey)),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: task.status == 'completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  task.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: task.status == 'completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 14,
                      color: Colors.grey),
                ),
                //task type
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: task.type.toLowerCase() == 'work'
                          ? Colors.green
                          : task.type.toLowerCase() == 'personal'
                              ? Colors.blue
                              : task.type.toLowerCase() == 'study'
                                  ? const Color.fromRGBO(255, 152, 0, 1)
                                  : task.type.toLowerCase() == 'meeting'
                                      ? Colors.purple
                                      : Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    task.type,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                task.notifierMe ? Icons.notifications : Icons.notifications_off,
                size: 18,
                color: task.notifierMe ? Colors.green : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

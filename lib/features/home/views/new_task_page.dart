import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scheduler_app_sms/core/widget/custom_button.dart';
import 'package:scheduler_app_sms/core/widget/custom_input.dart';
import 'package:scheduler_app_sms/features/home/provider/new_task_provider.dart';

import '../../../utils/app_colors.dart';

mainBottomSheet(
    BuildContext context, WidgetRef ref, GlobalKey<FormState> form) {
  var newTaskNotifier = ref.read(newTaskProvider.notifier);
  List<String> taskType = ['Personal', 'Work', 'Meeting', 'Study'];
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height - 80,
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 25,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(175, 30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 340,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Form(
                        key: form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      CustomColors.purpleLight,
                                      CustomColors.purpleDark,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CustomColors.purpleShadow,
                                      blurRadius: 10.0,
                                      spreadRadius: 5.0,
                                      offset: Offset(0.0, 0.0),
                                    ),
                                  ],
                                ),
                                child:
                                    Image.asset('assets/images/fab-delete.png'),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                const Text(
                                  'Add new task',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 20),
                                CustomTextFields(
                                  label: 'Title',
                                  hintText: 'Enter task title',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task title';
                                    }
                                    return null;
                                  },
                                  onSaved: (title) {
                                    newTaskNotifier.setTaskTitle(title!);
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomTextFields(
                                  label: 'Description',
                                  hintText: 'Enter task description',
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task description';
                                    }
                                    return null;
                                  },
                                  onSaved: (description) {
                                    newTaskNotifier
                                        .setTaskDescription(description!);
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomTextFields(
                                  label: 'Date',
                                  hintText: 'Enter task date',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task date';
                                    }
                                    return null;
                                  },
                                  onSaved: (date) {},
                                  isReadOnly: true,
                                  controller: TextEditingController(
                                    text: ref.watch(newTaskProvider).date != 0
                                        ? DateFormat('MMM, dd yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                ref
                                                    .watch(newTaskProvider)
                                                    .date))
                                        : null,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime(2025, 6, 7),
                                          onChanged: (date) {
                                        // newTaskNotifier.setTaskDate(date);
                                      }, onConfirm: (date) {
                                        newTaskNotifier.setTaskDate(date);
                                        setState(() {
                                          //ref.watch(newTaskProvider).date = date.millisecondsSinceEpoch;
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextFields(
                                  label: 'Time',
                                  hintText: 'Enter task time',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task time';
                                    }
                                    return null;
                                  },
                                  onSaved: (time) {},
                                  isReadOnly: true,
                                  controller: TextEditingController(
                                    text: ref.watch(newTaskProvider).time != 0
                                        ? DateFormat('hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                ref
                                                    .watch(newTaskProvider)
                                                    .time))
                                        : null,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: () async {
                                      DatePicker.showTimePicker(context,
                                          showTitleActions: true,
                                          onChanged: (time) {
                                        // newTaskNotifier.setTaskDate(date);
                                      }, onConfirm: (time) {
                                        newTaskNotifier.setTaskTime(time);
                                        setState(() {
                                          //ref.watch(newTaskProvider).date = date.millisecondsSinceEpoch;
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('Select type'),
                                  ),
                                  subtitle: SizedBox(
                                    height: 35,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: taskType.map((type) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: ChoiceChip(
                                              selectedColor: Colors.green,
                                              labelStyle: TextStyle(
                                                color: ref
                                                            .watch(
                                                                newTaskProvider)
                                                            .type ==
                                                        type
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              iconTheme: IconThemeData(
                                                color: ref
                                                            .watch(
                                                                newTaskProvider)
                                                            .type ==
                                                        type
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              label: Text(type),
                                              selected: ref
                                                      .watch(newTaskProvider)
                                                      .type ==
                                                  type,
                                              onSelected: (selected) {
                                                newTaskNotifier
                                                    .setTaskType(type);
                                                setState(
                                                  () {},
                                                );
                                              }),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //remind me radio buttons
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('Remind Me'),
                                  ),
                                  subtitle: SizedBox(
                                    height: 35,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: ChoiceChip(
                                                selectedColor: Colors.green,
                                                labelStyle: TextStyle(
                                                  color: ref
                                                          .watch(
                                                              newTaskProvider)
                                                          .notifierMe
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                iconTheme: IconThemeData(
                                                  color: ref
                                                          .watch(
                                                              newTaskProvider)
                                                          .notifierMe
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                label: const Text('Yes'),
                                                selected: ref
                                                    .watch(newTaskProvider)
                                                    .notifierMe,
                                                onSelected: (selected) {
                                                  newTaskNotifier
                                                      .setReminder(true);
                                                  setState(
                                                    () {},
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: ChoiceChip(
                                                selectedColor: Colors.green,
                                                labelStyle: TextStyle(
                                                  color: !ref
                                                          .watch(
                                                              newTaskProvider)
                                                          .notifierMe
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                iconTheme: IconThemeData(
                                                  color: !ref
                                                          .watch(
                                                              newTaskProvider)
                                                          .notifierMe
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                label: const Text('No'),
                                                selected: !ref
                                                    .watch(newTaskProvider)
                                                    .notifierMe,
                                                onSelected: (selected) {
                                                  newTaskNotifier
                                                      .setReminder(false);
                                                  setState(
                                                    () {},
                                                  );
                                                }),
                                          ),
                                        ]),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  text: 'Save Task',
                                  radius: 5,
                                  onPressed: () {
                                    if (form.currentState!.validate()) {
                                      form.currentState!.save();
                                      newTaskNotifier.saveTask(context, ref);
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

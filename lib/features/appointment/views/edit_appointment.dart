import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scheduler_app_sms/features/task/services/functions.dart';
import '../../../core/provider/users_provider.dart';
import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_dialog.dart';
import '../../../core/widget/custom_input.dart';
import '../../../utils/app_colors.dart';
import '../../auth/data/user_model.dart';
import '../../auth/provider/user_provider.dart';
import '../provider/new_app_provider.dart';

class EditAppointment extends ConsumerStatefulWidget {
  const EditAppointment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAppointmentState();
}

class _EditAppointmentState extends ConsumerState<EditAppointment> {
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var notifier = ref.read(editAppointmentProvider.notifier);
    var me = ref.watch(userProvider);
    List<String> taskType = ['Personal', 'Work', 'Meeting', 'Study'];
    var provider = ref.watch(editAppointmentProvider);
    var users = ref.watch(usersStream);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //resizeToAvoidBottomInset: true,
        body: users.when(
          data: (users) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(175, 30),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: form,
                    child: SingleChildScrollView(
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
                                'New Appointment',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 20),
                              TypeAheadField<UserModel>(
                                suggestionsCallback: (search) {
                                  return ref
                                      .watch(usersFilterProvider)
                                      .items
                                      .where((element) =>
                                          element.name
                                              .toLowerCase()
                                              .contains(search.toLowerCase()) ||
                                          element.email
                                              .toLowerCase()
                                              .contains(search.toLowerCase()))
                                      .toList();
                                },
                                builder: (context, controller, focusNode) {
                                  //wait for build to complete
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    controller.text = provider.recieverName;
                                    //remove focus
                                  });
                                  return CustomTextFields(
                                    label: 'Select User',
                                    hintText: 'Search user',
                                    initialValue: provider.recieverName,
                                    isReadOnly: true,
                                    focusNode: focusNode,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select user';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {},
                                  );
                                },
                                itemBuilder: (context, user) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(user.name),
                                    subtitle: Text(user.phoneNumber),
                                  );
                                },
                                onSelected: (user) {
                                  if (user.id == me.id) {
                                    CustomDialogs.toast(
                                        message:
                                            'You cannot create appointment for yourself');
                                    return;
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextFields(
                                label: 'Appointment Title',
                                initialValue: provider.title,
                                hintText: 'Enter appointment title',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter app title';
                                  }
                                  return null;
                                },
                                onSaved: (title) {
                                  notifier.setTitle(title!);
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextFields(
                                label: 'Description',
                                hintText: 'Enter appointment description',
                                maxLines: 3,
                                initialValue: provider.description,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter appointment description';
                                  }
                                  return null;
                                },
                                onSaved: (description) {
                                  notifier.setDescription(description!);
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextFields(
                                label: 'Date',
                                hintText: 'Enter appointment date',
                                controller: TextEditingController(
                                  text:
                                      ref.watch(editAppointmentProvider).date !=
                                              0
                                          ? formatDate(ref
                                              .watch(newAppointmentProvider)
                                              .date)
                                          : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter appointment date';
                                  }
                                  return null;
                                },
                                onSaved: (date) {},
                                isReadOnly: true,
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
                                      notifier.setDate(date);
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextFields(
                                label: 'Time',
                                hintText: 'Enter appointment time',
                                controller: TextEditingController(
                                  text:
                                      ref.watch(editAppointmentProvider).time !=
                                              0
                                          ? formatTime(ref
                                              .watch(newAppointmentProvider)
                                              .time)
                                          : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter appointment time';
                                  }
                                  return null;
                                },
                                onSaved: (time) {},
                                isReadOnly: true,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    DatePicker.showTimePicker(context,
                                        showTitleActions: true,
                                        onChanged: (time) {
                                      // newTaskNotifier.setTaskDate(date);
                                    }, onConfirm: (time) {
                                      notifier.setTime(time);
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
                                              color: provider.type == type
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            iconTheme: IconThemeData(
                                              color: provider.type == type
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            label: Text(type),
                                            selected: provider.type == type,
                                            onSelected: (selected) {
                                              notifier.setType(type);
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: ChoiceChip(
                                              selectedColor: Colors.green,
                                              labelStyle: TextStyle(
                                                color: provider.notifierMe
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              iconTheme: IconThemeData(
                                                color: provider.notifierMe
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              label: const Text('Yes'),
                                              selected: provider.notifierMe,
                                              onSelected: (selected) {
                                                notifier.setReminder(true);
                                              }),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: ChoiceChip(
                                              selectedColor: Colors.green,
                                              labelStyle: TextStyle(
                                                color: !provider.notifierMe
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              iconTheme: IconThemeData(
                                                color: !provider.notifierMe
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              label: const Text('No'),
                                              selected: !provider.notifierMe,
                                              onSelected: (selected) {
                                                notifier.setReminder(false);
                                              }),
                                        ),
                                      ]),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                text: 'Update Appointment',
                                radius: 5,
                                onPressed: () {
                                  if (form.currentState!.validate()) {
                                    form.currentState!.save();
                                    notifier.updateApp(context);
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
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) {
            return Center(
              child: Text(error.toString()),
            );
          },
        ),
      ),
    );
  }
}

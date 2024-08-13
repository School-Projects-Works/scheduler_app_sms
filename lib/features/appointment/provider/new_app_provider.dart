import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/appointment/services/app_services.dart';
import 'package:scheduler_app_sms/features/auth/data/user_model.dart';
import 'package:scheduler_app_sms/features/task/data/appointment_model.dart';
import 'package:scheduler_app_sms/features/task/services/functions.dart';

import '../../../core/sms_function.dart';
import '../../auth/provider/user_provider.dart';

final newAppointmentProvider =
    StateNotifierProvider<NewApp, AppointmentModel>((ref) => NewApp());

class NewApp extends StateNotifier<AppointmentModel> {
  NewApp() : super(AppointmentModel.empty());

  void setUser(UserModel user) {
    state = state.copyWith(
      recieverId: user.id,
      recieverName: user.name,
      recieverPhoto: user.photoUrl,
      recieverPhone: user.phoneNumber,
      recieverEmail: user.email,
      
    );
  }

  void setTitle(String s) {
    state = state.copyWith(title: s);
  }

  void setDescription(String s) {
    state = state.copyWith(description: s);
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date.millisecondsSinceEpoch);
  }

  void setTime(DateTime time) {
    state = state.copyWith(time: time.millisecondsSinceEpoch);
  }

  void setType(type) {
    state = state.copyWith(type: type);
  }

  void setReminder(bool bool) {
    state = state.copyWith(notifierMe: bool);
  }

  void createApp(BuildContext context, WidgetRef ref) async{
    CustomDialogs.loading(message: 'Creating Appointment');
    var user = ref.read(userProvider);
    state = state.copyWith(
      senderId: user.id,
      senderName: user.name,
      senderPhoto: user.photoUrl,
      senderPhone: user.phoneNumber,
      senderEmail: user.email,
      id: AppServices.appointmentId,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      users: [user.id, state.recieverId],
    );
    var result = await AppServices.createAppointment(state);
    if (result) {
      await sendMessage(state.recieverPhone, 'You have an appointment with ${state.senderName} on ${formatDateTime(state.date, state.time)}');
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Appointment created successfully',type: DialogType.success);
      Navigator.pop(context);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to create appointment',type: DialogType.error);
    }

  }

  
}


final editAppointmentProvider = StateNotifierProvider<EditApp, AppointmentModel>((ref) => EditApp());

class EditApp extends StateNotifier<AppointmentModel> {
  EditApp() : super(AppointmentModel.empty());

  void setAppointment(AppointmentModel app) {
    state = app;
  }

  void setTitle(String s) {
    state = state.copyWith(title: s);
  }

  void setDescription(String s) {
    state = state.copyWith(description: s);
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date.millisecondsSinceEpoch);
  }

  void setTime(DateTime time) {
    state = state.copyWith(time: time.millisecondsSinceEpoch);
  }

  void setType(type) {
    state = state.copyWith(type: type);
  }

  void setReminder(bool bool) {
    state = state.copyWith(notifierMe: bool);
  }

  void updateApp(BuildContext context) async{
    CustomDialogs.loading(message: 'Updating Appointment');
    var result = await AppServices.updateAppointment(state);
    if (result) {
      //send message to the reciever
      await sendMessage(state.recieverPhone, 'Appointment with ${state.senderName} has been updated, check your app for more details');
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Appointment updated successfully',type: DialogType.success);
      Navigator.pop(context);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to update appointment',type: DialogType.error);
    }

  }


  
}
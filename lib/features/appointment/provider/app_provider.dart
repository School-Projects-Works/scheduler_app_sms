import 'package:riverpod/riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_dialog.dart';
import 'package:scheduler_app_sms/features/auth/data/user_model.dart';
import 'package:scheduler_app_sms/features/task/data/appointment_model.dart';
import 'package:scheduler_app_sms/features/task/services/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/sms_function.dart';
import '../../auth/provider/user_provider.dart';
import '../services/app_services.dart';

final appointmentStream = StreamProvider<List<AppointmentModel>>((ref) async* {
  var user = ref.watch(userProvider);
  var data = AppServices.appointmentsStream(user.id);
  await for (var appointments in data) {
    ref.read(appointmentFilterProvider.notifier).setItem(appointments, );
    yield appointments;
  }
});

class AppointmentFilter {
  List<AppointmentModel> item;
  List<AppointmentModel> filter;
  List<AppointmentModel> pending;
  List<AppointmentModel> accepted;
  List<AppointmentModel> declined;
  List<AppointmentModel> completed;
  AppointmentModel? dueAppointment;

  AppointmentFilter({
    required this.item,
    required this.filter,
    required this.pending,
    required this.accepted,
    required this.declined,
    required this.completed,
    this.dueAppointment,
  });

  AppointmentFilter copyWith({
    List<AppointmentModel>? item,
    List<AppointmentModel>? filter,
    List<AppointmentModel>? pending,
    List<AppointmentModel>? accepted,
    List<AppointmentModel>? declined,
    List<AppointmentModel>? completed,
    AppointmentModel? dueAppointment,
  }) {
    return AppointmentFilter(
      item: item ?? this.item,
      filter: filter ?? this.filter,
      pending: pending ?? this.pending,
      accepted: accepted ?? this.accepted,
      declined: declined ?? this.declined,
      completed: completed ?? this.completed,
      dueAppointment: dueAppointment ?? this.dueAppointment,
    );
  }

  static AppointmentFilter empty = AppointmentFilter(
      item: [],
      filter: [],
      pending: [],
      accepted: [],
      declined: [],
      completed: []);
}

final appointmentFilterProvider =
    StateNotifierProvider<AppointmentFilterProvider, AppointmentFilter>((ref) {
  return AppointmentFilterProvider();
});

class AppointmentFilterProvider extends StateNotifier<AppointmentFilter> {
  AppointmentFilterProvider() : super(AppointmentFilter.empty);

  void setItem(List<AppointmentModel> appointments) async {
    
    var pending =
        appointments.where((element) => element.status == 'pending').toList();
    var accepted =
        appointments.where((element) => element.status == 'accepted').toList();
    var declined =
        appointments.where((element) => element.status == 'declined').toList();
    var completed =
        appointments.where((element) => element.status == 'completed').toList();
    var dueApp = accepted.where((element) {
      return isTimeDue(element.time, element.date);
    }).firstOrNull;
    state = state.copyWith(
      item: appointments,
      filter: appointments,
      pending: pending,
      accepted: accepted,
      declined: declined,
      completed: completed,
      dueAppointment: dueApp,
    );
  }

  void filter(String query) {
    var filtered = state.item.where((element) {
      return element.title.toLowerCase().contains(query.toLowerCase()) ||
          element.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    var pending =
        filtered.where((element) => element.status == 'pending').toList();
    var accepted =
        filtered.where((element) => element.status == 'accepted').toList();
    var declined =
        filtered.where((element) => element.status == 'declined').toList();
    var completed =
        filtered.where((element) => element.status == 'completed').toList();
    var dueApp = accepted.where((element) {
      return isTimeDue(element.time, element.date);
    }).firstOrNull;
    state = state.copyWith(
      filter: filtered,
      pending: pending,
      accepted: accepted,
      declined: declined,
      completed: completed,
      dueAppointment: dueApp,
    );
  }

  void updateTask(AppointmentModel copyWith) async{
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Updating appointment');
    var result = await AppServices.updateAppointment(copyWith);
    if (result) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Appointment updated successfully',type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to update appointment',type: DialogType.error);
    }

  }

  void deleteTask(String id) async{
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Deleting appointment');
    var result = await AppServices.deleteAppointment(id);
    if (result) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Appointment deleted successfully',type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to delete appointment',type: DialogType.error);
    }
  }
}


sendMessageOnApp(List<AppointmentModel>items,UserModel user)async{
 List<AppointmentModel> toBeNotified = items.where((task) {
    var isNotCompleted = task.status != 'completed' || task.status != 'ongoing';
    var past = isPast(task.time, task.date);

    return past && isNotCompleted;
  }).toList();
  List<AppointmentModel> frequentMessage = items.where((task) {
    var taskDate = isTimeDue(task.time, task.date);
    var isNotCompleted = task.status != 'completed' ||
        task.status != 'accepted' ||
        task.status != 'pending';
    var isTime = isExactTime(task.time, task.date);
    return (taskDate || isTime) && isNotCompleted;
  }).toList();
  List<AppointmentModel> exactTimeData = items.where((task) {
    var isNotCompleted = task.status != 'completed' ||
        task.status != 'accepted' ||
        task.status != 'pending';
    var isTime = isExactTime(task.time, task.date);
    return isTime && isNotCompleted;
  }).toList();
  if (exactTimeData.isNotEmpty) {
    print('SMS Sent====== for exact');
    var message =
        "Your following appointment needs your attention\n${exactTimeData.map((e) => '${e.title} : ${formatDateTime(e.date, e.time)}').join('\n')}";
    await sendMessage(user.phoneNumber, message);
  }
  if (frequentMessage.isNotEmpty) {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lastTime = prefs.getInt('lastTime') ?? 0;
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - lastTime >= 1200000) {
      print('SMS Sent====== for frequent');
      var message =
          "You have ${frequentMessage.length} appointment(s) that needs your attention";
      await sendMessage(user.phoneNumber, message);
      await prefs.setInt('lastTime', currentTime);
    }
  }
  if (toBeNotified.isNotEmpty) {
    var message =
        "Your following appointment needs your attention\n${toBeNotified.map((e) => '${e.title} : ${formatDateTime(e.date, e.time)}').join('\n')}";
    var hash = message.hashCode.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stored = prefs.getString('appointments') ?? '';
    if (stored != hash) {
       await prefs.setString('appointments', hash);
      print('SMS Sent====== for past stored: $stored hash: $hash');
      //  await sendMessage(user.phoneNumber, message);
    } else {
      print('NNo SMS Sent======');
    }
  }
  }

import 'package:riverpod/riverpod.dart';
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
    ref.read(appointmentFilterProvider.notifier).setItem(appointments, user);
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

  void setItem(List<AppointmentModel> appointments, UserModel user) async {
    List<AppointmentModel> toBeNotified = appointments.where((task) {
      var taskDate = isTimeDue(task.time, task.date);
      var isNotCompleted = task.status != 'completed' ||
          task.status != 'accepted' ||
          task.status != 'pending';
      var past = isPast(task.time, task.date);
      var isTime = isExactTime(task.time, task.date);
      return (taskDate || past || isTime) && isNotCompleted;
    }).toList();
    if (toBeNotified.isNotEmpty) {
      var ids = toBeNotified.map((e) => e.id).toList().join(',');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var stored = prefs.getString('appointments') ?? '';
      if (stored != ids) {
        var message =
            "Your following appointments needs your attention\n${toBeNotified.map((e) => '${e.title} : ${formatDateTime(e.date, e.time)}').join('\n')}";
        await sendMessage(user.phoneNumber, message);
        await prefs.setString('appointments', ids);      
      }
    }
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

  void updateTask(AppointmentModel copyWith) {}

  void deleteTask(String id) {}
}

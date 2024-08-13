import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler_app_sms/features/task/data/appointment_model.dart';

class AppServices{
  static final CollectionReference _appointmentCollection = FirebaseFirestore.instance.collection('appointments');

  static String appointmentId = _appointmentCollection.doc().id;

  static Future<bool> createAppointment(AppointmentModel appointment) async {
    try {
      await _appointmentCollection.doc(appointment.id).set(appointment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateAppointment(AppointmentModel appointment) async {
    try {
      await _appointmentCollection.doc(appointment.id).update(appointment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await _appointmentCollection.doc(appointmentId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<AppointmentModel>> appointmentsStream(String userId) {
    return _appointmentCollection.where('users', arrayContains: userId).snapshots().map((snapshot) => snapshot.docs.map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }
}
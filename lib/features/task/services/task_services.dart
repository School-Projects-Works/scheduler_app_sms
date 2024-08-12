import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';

class TaskServices {
  static CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  static String generateId() {
    return taskCollection.doc().id;
  }

  static Future<bool> addTask(TaskModel task) async {
    try {
      await taskCollection.doc(task.id).set(task.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTask(TaskModel task) async {
    try {
      await taskCollection.doc(task.id).update(task.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTask(String id) async {
    try {
      await taskCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<TaskModel>> taskStream({required String userId}) {
    return taskCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}

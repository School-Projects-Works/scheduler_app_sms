import 'dart:convert';

class TaskModel {
  String id;
  String title;
  String userId;
  String description;
  int date;
  int time;
  String status;
  String type;
  bool notifierMe;
  int createdAt;
  TaskModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.description,
    required this.date,
    required this.time,
     this.status= 'pending',
    required this.type,
    required this.notifierMe,
    required this.createdAt,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? userId,
    String? description,
    int? date,
    int? time,
    String? status,
    String? type,
    bool? notifierMe,
    int? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
      notifierMe: notifierMe ?? this.notifierMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'userId': userId});
    result.addAll({'description': description});
    result.addAll({'date': date});
    result.addAll({'time': time});
    result.addAll({'status': status});
    result.addAll({'type': type});
    result.addAll({'notifierMe': notifierMe});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      userId: map['userId'] ?? '',
      description: map['description'] ?? '',
      date: map['date']?.toInt() ?? 0,
      time: map['time']?.toInt() ?? 0,
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      notifierMe: map['notifierMe'] ?? false,
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, userId: $userId, description: $description, date: $date, time: $time, status: $status, type: $type, notifierMe: $notifierMe, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TaskModel &&
      other.id == id &&
      other.title == title &&
      other.userId == userId &&
      other.description == description &&
      other.date == date &&
      other.time == time &&
      other.status == status &&
      other.type == type &&
      other.notifierMe == notifierMe &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      userId.hashCode ^
      description.hashCode ^
      date.hashCode ^
      time.hashCode ^
      status.hashCode ^
      type.hashCode ^
      notifierMe.hashCode ^
      createdAt.hashCode;
  }

  static TaskModel empty() {
    return TaskModel(
      id: '',
      title: '',
      userId: '',
      description: '',
      date: 0,
      time: 0,
      status: '',
      type: '',
      notifierMe: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

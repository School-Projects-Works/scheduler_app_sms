import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppointmentModel {
  String id;
  String title;
  String description;
  int date;
  int time;
  String status;
  String type;
  bool notifierMe;
  List<String> users;
  String senderId;
  String senderName;
  String senderPhoto;
  String senderPhone;
  String senderEmail;
  String recieverId;
  String recieverName;
  String recieverPhoto;
  String recieverPhone;
  String recieverEmail;
  int createdAt;
  AppointmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.status = 'pending',
    required this.type,
    required this.notifierMe,
    this.users= const [],
    required this.senderId,
    required this.senderName,
    required this.senderPhoto,
    required this.senderPhone,
    required this.senderEmail,
    required this.recieverId,
    required this.recieverName,
    required this.recieverPhoto,
    required this.recieverPhone,
    required this.recieverEmail,
    required this.createdAt,
  });

  static AppointmentModel empty() {
    return AppointmentModel(
      id: '',
      title: '',
      description: '',
      date: 0,
      time: 0,
      status: 'pending',
      users: [],
      senderId: '',
      senderName: '',
      senderPhoto: '',
      senderPhone: '',
      senderEmail: '',
      recieverId: '',
      recieverName: '',
      recieverPhoto: '',
      recieverPhone: '',
      recieverEmail: '',
      type: '',
      notifierMe: false,
      createdAt: 0,
    );
  }

  AppointmentModel copyWith({
    String? id,
    String? title,
    String? description,
    int? date,
    int? time,
    String? status,
    String? type,
    bool? notifierMe,
    List<String>? users,
    String? senderId,
    String? senderName,
    String? senderPhoto,
    String? senderPhone,
    String? senderEmail,
    String? recieverId,
    String? recieverName,
    String? recieverPhoto,
    String? recieverPhone,
    String? recieverEmail,
    int? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
      notifierMe: notifierMe ?? this.notifierMe,
      users: users ?? this.users,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhoto: senderPhoto ?? this.senderPhoto,
      senderPhone: senderPhone ?? this.senderPhone,
      senderEmail: senderEmail ?? this.senderEmail,
      recieverId: recieverId ?? this.recieverId,
      recieverName: recieverName ?? this.recieverName,
      recieverPhoto: recieverPhoto ?? this.recieverPhoto,
      recieverPhone: recieverPhone ?? this.recieverPhone,
      recieverEmail: recieverEmail ?? this.recieverEmail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'date': date});
    result.addAll({'time': time});
    result.addAll({'status': status});
    result.addAll({'type': type});
    result.addAll({'notifierMe': notifierMe});
    result.addAll({'users': users});
    result.addAll({'senderId': senderId});
    result.addAll({'senderName': senderName});
    result.addAll({'senderPhoto': senderPhoto});
    result.addAll({'senderPhone': senderPhone});
    result.addAll({'senderEmail': senderEmail});
    result.addAll({'recieverId': recieverId});
    result.addAll({'recieverName': recieverName});
    result.addAll({'recieverPhoto': recieverPhoto});
    result.addAll({'recieverPhone': recieverPhone});
    result.addAll({'recieverEmail': recieverEmail});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date']?.toInt() ?? 0,
      time: map['time']?.toInt() ?? 0,
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      notifierMe: map['notifierMe'] ?? false,
      users: List<String>.from(map['users']),
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhoto: map['senderPhoto'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      recieverId: map['recieverId'] ?? '',
      recieverName: map['recieverName'] ?? '',
      recieverPhoto: map['recieverPhoto'] ?? '',
      recieverPhone: map['recieverPhone'] ?? '',
      recieverEmail: map['recieverEmail'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) => AppointmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppointmentModel(id: $id, title: $title, description: $description, date: $date, time: $time, status: $status, type: $type, notifierMe: $notifierMe, users: $users, senderId: $senderId, senderName: $senderName, senderPhoto: $senderPhoto, senderPhone: $senderPhone, senderEmail: $senderEmail, recieverId: $recieverId, recieverName: $recieverName, recieverPhoto: $recieverPhoto, recieverPhone: $recieverPhone, recieverEmail: $recieverEmail, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppointmentModel &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.date == date &&
      other.time == time &&
      other.status == status &&
      other.type == type &&
      other.notifierMe == notifierMe &&
      listEquals(other.users, users) &&
      other.senderId == senderId &&
      other.senderName == senderName &&
      other.senderPhoto == senderPhoto &&
      other.senderPhone == senderPhone &&
      other.senderEmail == senderEmail &&
      other.recieverId == recieverId &&
      other.recieverName == recieverName &&
      other.recieverPhoto == recieverPhoto &&
      other.recieverPhone == recieverPhone &&
      other.recieverEmail == recieverEmail &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      date.hashCode ^
      time.hashCode ^
      status.hashCode ^
      type.hashCode ^
      notifierMe.hashCode ^
      users.hashCode ^
      senderId.hashCode ^
      senderName.hashCode ^
      senderPhoto.hashCode ^
      senderPhone.hashCode ^
      senderEmail.hashCode ^
      recieverId.hashCode ^
      recieverName.hashCode ^
      recieverPhoto.hashCode ^
      recieverPhone.hashCode ^
      recieverEmail.hashCode ^
      createdAt.hashCode;
  }
}

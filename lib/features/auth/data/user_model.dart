import 'dart:convert';

class UserModel {
  String id;
  String email;
  String name;
  String? photoUrl;
  String phoneNumber;
  String? password;
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.phoneNumber,
    this.password,
  });
  
  static UserModel empty = UserModel(id: '', email: '', name: '', phoneNumber: '');

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'name': name});
    if(photoUrl != null){
      result.addAll({'photoUrl': photoUrl});
    }
    result.addAll({'phoneNumber': phoneNumber});
    
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'] ?? '',
      
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, photoUrl: $photoUrl, phoneNumber: $phoneNumber, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.photoUrl == photoUrl &&
      other.phoneNumber == phoneNumber &&
      other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      photoUrl.hashCode ^
      phoneNumber.hashCode ^
      password.hashCode;
  }
}

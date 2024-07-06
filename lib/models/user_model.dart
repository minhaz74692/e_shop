import 'dart:convert';

UserResponseModel userResponseFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

class UserModel {
  String? userId;
  String? userName;
  String? emailId;
  String? phone;
  String? role;

  UserModel({
    this.userId,
    required this.userName,
    required this.emailId,
    required this.phone,
    required this.role,
  });

  UserModel.fromFirestore(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    emailId = json['email'];
    phone = json['phone'];
    role = json['role'] ?? 'reguler';
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['email'] = emailId;
    data['phone'] = phone;
    data['role'] = role;
    return data;
  }
}

class UserResponseModel {
  int? code;
  String? message;

  UserResponseModel({this.code, this.message});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

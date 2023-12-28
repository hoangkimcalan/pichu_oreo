import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String address;
  final String gender;
  final String workplace;
  final String avatar;
  final String background;
  late String recipientToken;
  final List<String> friendList;
  final List<String> roles;
  final int resetPwToken;
  final DateTime? expiryResetPwTokenDate;
  final DateTime? dateOfBirth;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.gender,
    required this.workplace,
    required this.avatar,
    required this.background,
    required this.recipientToken,
    required this.friendList,
    required this.roles,
    required this.resetPwToken,
    this.expiryResetPwTokenDate,
    this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'username': username});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'password': password});
    result.addAll({'address': address});
    result.addAll({'gender': gender});
    result.addAll({'workplace': workplace});
    result.addAll({'avatar': avatar});
    result.addAll({'background': background});
    result.addAll({'recipientToken': recipientToken});
    result.addAll({'friendList': friendList});
    result.addAll({'roles': roles});
    result.addAll({'resetPwToken': resetPwToken});
    if (expiryResetPwTokenDate != null) {
      result.addAll({
        'expiryResetPwTokenDate': expiryResetPwTokenDate!.millisecondsSinceEpoch
      });
    }
    if (dateOfBirth != null) {
      result.addAll({'dateOfBirth': dateOfBirth!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      workplace: map['workplace'] ?? '',
      avatar: map['avatar'] ?? '',
      background: map['background'] ?? '',
      recipientToken: map['recipientToken'] ?? '',
      friendList:
          map['friendList'] != null ? List<String>.from(map['friendList']) : [],
      roles: List<String>.from(map['roles']),
      resetPwToken: map['resetPwToken']?.toInt() ?? 0,
      expiryResetPwTokenDate: map['expiryResetPwTokenDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryResetPwTokenDate'])
          : null,
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? address,
    String? gender,
    String? workplace,
    String? avatar,
    String? background,
    String? recipientToken,
    List<String>? friendList,
    List<String>? roles,
    int? resetPwToken,
    DateTime? expiryResetPwTokenDate,
    DateTime? dateOfBirth,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      workplace: workplace ?? this.workplace,
      avatar: avatar ?? this.avatar,
      background: background ?? this.background,
      recipientToken: recipientToken ?? this.recipientToken,
      friendList: friendList ?? this.friendList,
      roles: roles ?? this.roles,
      resetPwToken: resetPwToken ?? this.resetPwToken,
      expiryResetPwTokenDate:
          expiryResetPwTokenDate ?? this.expiryResetPwTokenDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, password: $password, address: $address, gender: $gender, workplace: $workplace, avatar: $avatar, background: $background, recipientToken: $recipientToken, friendList: $friendList, roles: $roles, resetPwToken: $resetPwToken, expiryResetPwTokenDate: $expiryResetPwTokenDate, dateOfBirth: $dateOfBirth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.address == address &&
        other.gender == gender &&
        other.workplace == workplace &&
        other.avatar == avatar &&
        other.background == background &&
        other.recipientToken == recipientToken &&
        listEquals(other.friendList, friendList) &&
        listEquals(other.roles, roles) &&
        other.resetPwToken == resetPwToken &&
        other.expiryResetPwTokenDate == expiryResetPwTokenDate &&
        other.dateOfBirth == dateOfBirth;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        address.hashCode ^
        gender.hashCode ^
        workplace.hashCode ^
        avatar.hashCode ^
        background.hashCode ^
        recipientToken.hashCode ^
        friendList.hashCode ^
        roles.hashCode ^
        resetPwToken.hashCode ^
        expiryResetPwTokenDate.hashCode ^
        dateOfBirth.hashCode;
  }
}

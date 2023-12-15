import 'package:flutter/material.dart';
import 'package:pichu_oreo/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    username: '',
    fistName: '',
    fullName: '',
    email: '',
    phone: '',
    password: '',
    address: '',
    gender: '',
    workpalace: '',
    avatar: '',
    background: '',
    recipientToken: '',
    friendList: [],
    roles: [],
    resetPwToken: 0,
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}

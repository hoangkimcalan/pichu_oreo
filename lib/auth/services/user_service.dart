// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class UserService {
  Future<String> getUserId({
    required BuildContext context,
    required String username,
  }) async {
    Map<String, dynamic> requestData = {
      "username": username,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authorization');

    http.Response res = await http.post(
      Uri.parse('$uri/api/auth/getDataFrUsername'),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token!}'
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(res.body);
    log('data get user info $jsonResponse');
    Map<String, dynamic> ecodeValue = jsonResponse['data'];

    return ecodeValue['id'];
  }

  Future<void> updateUserInfo({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String workPlace,
    List<File>? images,
    required String phone,
    required String address,
    required String avatar,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dytgqaiyv', 'xxq9oepz');
      List<String> imageUrls = [];
      if (images!.isNotEmpty) {
        for (var i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path, folder: "KimCa"),
          );
          imageUrls.add(res.secureUrl);
        }
      }

      Map<String, dynamic> requestData = {
        "firstNameEdit": firstName,
        "lastNameEdit": lastName,
        "workPlaceEdit": workPlace,
        "addressEdit": address,
        "phoneEdit": phone,
        "avatarEdit": images.isEmpty ? avatar : imageUrls[0],
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      http.Response res = await http.post(
        Uri.parse('$uri/api/func/user/updateUserInfo'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token!}'
        },
      );

      Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      Map<String, dynamic> ecodeValue = jsonResponse['data'];

      Map<String, dynamic> userData = {
        "id": ecodeValue['id'],
        "username": ecodeValue['username'],
        "email": ecodeValue['email'],
        "roles": ecodeValue['roles'],
        "avatar": ecodeValue['avatar'],
        "firstName": ecodeValue['firstName'],
        "lastName": ecodeValue['lastName'],
        "workplace": ecodeValue['workplace'],
        "address": ecodeValue['address'],
        "phone": ecodeValue['phone']
      };

      String userDataJson = json.encode(userData);

      var userProvider = Provider.of<UserProvider>(context, listen: false);

      userProvider.setUser(userDataJson);

      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setString('authorization', '');

      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

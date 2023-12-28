import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
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

  Future<String> updateUserInfo({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String workPlace,
    List<File>? images,
    required String phone,
    required String address,
    required String avatar,
  }) async {
    final cloudinary = CloudinaryPublic('dytgqaiyv', 'xxq9oepz');
    List<String> imageUrls = [];
    if (images!.isNotEmpty) {
      log("HELLOOO");
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

    log("Data res update user $requestData");

    http.Response res = await http.post(
      Uri.parse('$uri/api/func/user/updateUserInfo'),
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
}

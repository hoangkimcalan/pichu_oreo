// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/common_widgets/error_handling.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReactService {
  Future<void> createReact({
    required BuildContext context,
    required String postId,
    required String referenceId,
    required int status,
    required String type,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        "postId": postId,
        "referenceId": referenceId,
        "status": status,
        "type": type,
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      http.Response res = await http.post(
        Uri.parse('$uri/api/func/post/createReact'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token!}'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //showSnackBar(context, 'Create post successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/common_widgets/error_handling.dart';
import 'package:pichu_oreo/models/post.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/responsive/responsive_layout_screen.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostServices {
  Future<void> createPost({
    required BuildContext context,
    required String userId,
    String? description,
    required String stautus,
    List<File>? images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dytgqaiyv', 'xxq9oepz');
      List<Map<String, dynamic>> imageUrls = [];
      for (var i = 0; i < images!.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: userId),
        );
        imageUrls.add({
          'seq': i.toString(),
          'url': res.secureUrl,
          'type': 'image',
        });
      }

      Map<String, dynamic> requestData = {
        "content": description,
        "images": imageUrls,
        "status": stautus,
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      http.Response res = await http.post(
        Uri.parse('$uri/api/func/post/createPost'),
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
          showSnackBar(context, 'Create post successfully!');
          Navigator.of(context).pushNamedAndRemoveUntil(
            ResponsiveLayout.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAllPosts(
      {required BuildContext context, required int page}) async {
    List<Map<String, dynamic>> _postList = [];

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      Map<String, dynamic> requestData = {
        "page": page,
      };

      http.Response res = await http.post(
        Uri.parse('$uri/api/func/post/getAllPosts'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token!}'
        },
      );

      Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      List<Map<String, dynamic>> ecodeValue =
          List<Map<String, dynamic>>.from(jsonResponse['data']);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (var i = 0; i < ecodeValue.length; i++) {
            _postList.add(ecodeValue[i]);
          }
        },
      );
    } catch (e) {
      log('error $e');
      showSnackBar(context, e.toString());
    }
    return _postList;
  }
}

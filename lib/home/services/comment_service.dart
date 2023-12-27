// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/common_widgets/error_handling.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CommentServices {
  Future<void> createComment({
    required BuildContext context,
    required String userId,
    String? content,
    required String postId,
    required String referenceId,
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
        "content": content,
        "images": imageUrls,
        "postId": postId,
        "referenceId": referenceId,
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      await http.post(
        Uri.parse('$uri/api/func/comment/createComment'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token!}'
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getCommentParent(
      {required BuildContext context,
      required int page,
      required String postId}) async {
    List<Map<String, dynamic>> commentList = [];

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      Map<String, dynamic> requestData = {
        "page": page,
        "postId": postId,
      };

      http.Response res = await http.post(
        Uri.parse('$uri/api/func/comment/getCommentParent'),
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
            commentList.add(ecodeValue[i]);
          }
        },
      );
    } catch (e) {
      log('error $e');
      showSnackBar(context, e.toString());
    }
    return commentList;
  }

  Future<List<Map<String, dynamic>>> getCommentReply(
      {required BuildContext context, required String parentCommentId}) async {
    List<Map<String, dynamic>> replyList = [];

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      Map<String, dynamic> requestData = {
        "parentCommentId": parentCommentId,
      };

      http.Response res = await http.post(
        Uri.parse('$uri/api/func/comment/getReply'),
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
            replyList.add(ecodeValue[i]);
          }
        },
      );
    } catch (e) {
      log('error $e');
      showSnackBar(context, e.toString());
    }
    return replyList;
  }
}

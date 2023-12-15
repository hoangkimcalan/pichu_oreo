import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pichu_oreo/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    void getData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');
      log("token $token");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/images/logo-main.svg',
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          )
        ],
      ),
      body: GestureDetector(
        onTap: getData,
        child: Text('data'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pichu_oreo/home/screens/create_post_screen.dart';
import 'package:pichu_oreo/home/screens/feed_screen.dart';
import 'package:pichu_oreo/home/screens/profile_screen.dart';
import 'package:pichu_oreo/home/screens/search_screen.dart';

const webScreenSize = 600;

String uri = 'http://192.168.1.80:8080';

List<Widget> homeScreenItem = [
  const FeedScreen(),
  const SearchScreen(),
  const CreatePostScreen(),
  const Text('Notification screen'),
  const ProfileScreen()
];

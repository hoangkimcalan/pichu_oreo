import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pichu_oreo/home/services/post_service.dart';
import 'package:pichu_oreo/home/widgets/post_card.dart';
import 'package:pichu_oreo/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:pichu_oreo/providers/user_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  final PostServices postServices = PostServices();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  List<Map<String, dynamic>> _postList = [];

  Future<void> fetchData() async {
    try {
      log("Fetching post...");
      List<Map<String, dynamic>> newData =
          await postServices.getAllPosts(context: context, page: _currentPage);
      if (newData.isEmpty) {
        return;
      }
      _currentPage++;
      setState(() {
        _postList.addAll(newData);
      });
      log("data new here");
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<void> refreshData() async {
    try {
      log("Fetching data...");
      List<Map<String, dynamic>> newData =
          await postServices.getAllPosts(context: context, page: 0);
      if (newData.isEmpty) {
        return;
      }
      _currentPage++;
      setState(() {
        _postList = [];
        _postList.addAll(newData);
      });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<UserProvider>(context).user;

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
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshData();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _postList.length + 1,
          itemBuilder: (context, index) {
            if (index < _postList.length) {
              Map<String, dynamic> itemPost = _postList[index];
              return PostCard(snap: itemPost);
            } else {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

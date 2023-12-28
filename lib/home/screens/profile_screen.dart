import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/home/screens/edit_profile_screen.dart';
import 'package:pichu_oreo/home/services/post_service.dart';
import 'package:pichu_oreo/home/widgets/post_card.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/utils/colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  final PostServices postServices = PostServices();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _myPostList = [];
  int _currentPage = 0;

  Future<void> fetchData() async {
    try {
      log("Fetching my post...");
      List<Map<String, dynamic>> newData =
          await postServices.getMyPosts(context: context, page: _currentPage);
      if (newData.isEmpty) {
        return;
      }
      _currentPage++;
      setState(() {
        _myPostList.addAll(newData);
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

  void navigateToEditProfile() {
    Navigator.pushNamed(context, EditProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {},
              child: const SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Icon(Icons.settings)],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.username,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                user.email,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: navigateToEditProfile,
                child: SizedBox(
                  width: 200,
                  child: Container(
                    width: 380,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color(0xff9796f0),
                          Color.fromARGB(255, 251, 159, 182),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: _myPostList.length + 1,
                itemBuilder: (context, index) {
                  if (index < _myPostList.length) {
                    Map<String, dynamic> itemPost = _myPostList[index];
                    return PostCard(
                      snap: itemPost,
                    );
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

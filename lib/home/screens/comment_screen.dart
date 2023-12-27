import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/services/user_service.dart';
import 'package:pichu_oreo/common_widgets/text_field_input.dart';
import 'package:pichu_oreo/home/services/comment_service.dart';
import 'package:pichu_oreo/home/widgets/comment_card.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommentServices commentServices = CommentServices();
  final UserService userService = UserService();
  final TextEditingController _commentController = TextEditingController();
  String buttonText = 'Hi';
  List<File> images = [];
  int _current = 0;
  int _currentPage = 0;
  final CarouselController _controller = CarouselController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _commentList = [];
  String textReply = "";
  String commentId = "";
  bool isReply = false;

  String authorCmtRep = "";
  String idAuthorCmtRep = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchData();
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void clearPostMem() {
    setState(() {
      images = [];
      _commentController.text = "";
      isReply = false;
    });
  }

  void createComment(String userId, String postId, String referenceId) {
    if (_commentController.text.isNotEmpty || images.isNotEmpty) {
      commentServices.createComment(
        context: context,
        userId: userId,
        postId: postId,
        content:
            _commentController.text.replaceAll(authorCmtRep, idAuthorCmtRep),
        referenceId: referenceId,
        images: images,
      );

      clearPostMem();
    } else {
      showSnackBar(context, 'Oops! Fill in the magic and add a pic. 📸✨');
    }
  }

  Future<void> fetchData() async {
    try {
      log("Fetching comment...");
      List<Map<String, dynamic>> newData =
          await commentServices.getCommentParent(
        context: context,
        page: _currentPage,
        postId: widget.snap['postId'],
      );
      if (newData.isEmpty) {
        return;
      }
      _currentPage++;
      setState(() {
        _commentList.addAll(newData);
      });
      log("data new here $_commentList");
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      height: MediaQuery.of(context).size.height * 9 / 11,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            children: [
              Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8),
              Divider(
                thickness: 1,
                color: Colors.grey,
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _commentList.length + 1,
              itemBuilder: (context, index) {
                if (index < _commentList.length) {
                  Map<String, dynamic> itemPost = _commentList[index];
                  return CommentCard(
                    snap: itemPost,
                    onButtonClicked: (userTag, commentIdPr, isReplyS) async {
                      String userIdTag = await userService.getUserId(
                          context: context, username: userTag);
                      setState(() {
                        _commentController.text = "@$userTag ";
                        isReply = isReplyS;
                        commentId = commentIdPr;
                        authorCmtRep = "@$userTag";
                        idAuthorCmtRep = "#$userIdTag#";
                      });
                    },
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
          ),
          if (isReply)
            Container(
              color: const Color.fromARGB(252, 231, 231, 231),
              height: 40,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Replying",
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _commentController.text = '';
                          isReply = false;
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: images.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                CarouselSlider(
                                  items: images.map((e) {
                                    return Builder(
                                      builder: (BuildContext context) =>
                                          Image.file(
                                        e,
                                        fit: BoxFit.cover,
                                        height: 250,
                                      ),
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    height: 250,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: ((index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: images.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 211, 78, 111))
                                              .withOpacity(_current == entry.key
                                                  ? 0.9
                                                  : 0.4),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          )
                        : TextFieldInput(
                            textEditingController: _commentController,
                            hintText: isReply
                                ? textReply
                                : 'Comment as ${user.username}',
                            textInputType: TextInputType.text,
                            onTextChanged: (text) {
                              setState(() {
                                buttonText = text.isNotEmpty ? 'Post' : 'Post';
                              });
                            },
                            isReply: isReply,
                          ),
                  ),
                ),
                InkWell(
                  onTap: () => createComment(
                    user.id,
                    widget.snap['postId'],
                    isReply ? commentId : widget.snap['postId'],
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: (_commentController.text.isNotEmpty ||
                            images.isNotEmpty)
                        ? const Text(
                            'Post',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImages,
                            child: const SizedBox(
                              child: Icon(
                                Icons.image_outlined,
                                color: Color(0xFF8d9096),
                                size: 32,
                              ),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

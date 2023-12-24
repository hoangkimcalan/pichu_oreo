import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/common_widgets/like_animation.dart';
import 'package:pichu_oreo/home/screens/comment_screen.dart';
import 'package:pichu_oreo/home/services/react_service.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _current = 0;
  bool showFullText = false;
  final CarouselController _controller = CarouselController();
  final ReactService reactService = ReactService();
  late bool isLikePost;
  late int likeCount;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    @override
    void initState() {
      super.initState();
      isLikePost = widget.snap['hasReacted'];
      likeCount = widget.snap['likeCount'];
    }

    Future<void> likePost() async {
      try {
        log("Like post...");
        await reactService.createReact(
          context: context,
          postId: widget.snap['postId'],
          referenceId: widget.snap['postId'],
          status: widget.snap['hasReacted'] ? 0 : 1,
          type: "LIKE",
        );
      } catch (e) {
        log('Error fetching data: $e');
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['poster']['username'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getFormattedTime(widget.snap['createDate']),
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showFullText = !showFullText;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: showFullText
                                      ? widget.snap['content']
                                      : widget.snap['content'].length > 100
                                          ? '${widget.snap['content'].substring(0, 100)}...'
                                          : widget.snap['content'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                if (!showFullText &&
                                    widget.snap['content'].length > 100)
                                  const TextSpan(
                                    text: ' Show more',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  widget.snap['images'] != null
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: Column(
                            children: [
                              CarouselSlider(
                                items: (List<Map<String, dynamic>>.from(
                                  widget.snap['images'],
                                )).asMap().entries.map((e) {
                                  int index = e.key;
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        Image.network(
                                      widget.snap['images'][index]['url'],
                                      fit: BoxFit.cover,
                                      width: 300,
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
                                children: (List<Map<String, dynamic>>.from(
                                  widget.snap['images'],
                                )).asMap().entries.map((entry) {
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
                                        color: (Theme.of(context).brightness ==
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
                      : const SizedBox(height: 2),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      LikeAnimation(
                        isAnimating: isLikePost,
                        child: IconButton(
                          onPressed: () {
                            likePost();
                            setState(() {
                              isLikePost = !isLikePost;
                              log("isReact $isLikePost");
                            });
                          },
                          icon: !isLikePost
                              ? const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Color(0xFF8d9096),
                                  size: 32,
                                )
                              : const Icon(
                                  Icons.favorite_outlined,
                                  color: Colors.redAccent,
                                  size: 32,
                                ),
                        ),
                      ),
                      Text(
                        widget.snap['likeCounts'].toString(),
                        style: const TextStyle(
                          color: Color(0xFF8d9096),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              // Return the dialog widget
                              return CommentScreen(snap: widget.snap);
                            },
                          );
                        },
                        child: const SizedBox(
                          child: Icon(
                            Icons.comment_outlined,
                            color: Color(0xFF8d9096),
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.snap['commentCount'].toString(),
                        style: const TextStyle(
                          color: Color(0xFF8d9096),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const SizedBox(
                          child: Icon(
                            Icons.bookmark_outline,
                            color: Color(0xFF8d9096),
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {},
                        child: const SizedBox(
                          child: Icon(
                            Icons.share_outlined,
                            color: Color(0xFF8d9096),
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          color: const Color.fromARGB(255, 227, 227, 227),
        ),
      ],
    );
  }
}

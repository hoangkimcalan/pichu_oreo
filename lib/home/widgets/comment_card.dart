import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/home/services/comment_service.dart';
import 'package:pichu_oreo/home/widgets/reply_card.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final Function(String, String, bool) onButtonClicked;
  const CommentCard({super.key, this.snap, required this.onButtonClicked});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  int _current = 0;
  bool showFullText = false;
  bool isLoading = false;
  bool isViewReply = false;
  final CarouselController _controller = CarouselController();
  final CommentServices commentServices = CommentServices();
  final List<Map<String, dynamic>> _replyList = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchReply() async {
    try {
      log("Fetching reply...");
      setState(() {
        isLoading = true;
        isViewReply = true;
      });
      List<Map<String, dynamic>> newData =
          await commentServices.getCommentReply(
        context: context,
        parentCommentId: widget.snap['commentId'],
      );
      if (newData.isEmpty) {
        return;
      }
      setState(() {
        _replyList.addAll(newData);
        isLoading = false;
      });
      log("data reply here $_replyList");
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    NetworkImage(widget.snap['poster']['authorAvatar']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.snap['poster']['username'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        getFormattedTimeCmt(widget.snap['createDate']),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 110, 110, 110),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_outline_outlined,
                      color: Color(0xFF8d9096),
                      size: 20,
                    ),
                  ),
                  Text("123")
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 64),
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
              ),
            ],
          ),
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
                                    vertical: 8.0,
                                    horizontal: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 211, 78, 111))
                                        .withOpacity(
                                            _current == entry.key ? 0.9 : 0.4),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: 0),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: GestureDetector(
              onTap: () {
                widget.onButtonClicked("${widget.snap['poster']['username']}",
                    "${widget.snap['commentId']}", true);
              },
              child: const SizedBox(
                child: Text(
                  "Reply",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 112, 112, 112),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          if (widget.snap['replyCounts'] > 0)
            !isViewReply
                ? GestureDetector(
                    onTap: () {
                      fetchReply();
                    },
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            indent: 20.0,
                            endIndent: 10.0,
                            thickness: 0.3,
                          ),
                        ),
                        Text(
                          "View ${widget.snap['replyCounts']} replys",
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 10.0,
                            endIndent: 20.0,
                            thickness: 0.3,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: Column(
                      children: [
                        !isLoading
                            ? ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: _replyList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < _replyList.length) {
                                    Map<String, dynamic> itemReply =
                                        _replyList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ReplyCard(snap: itemReply),
                                    );
                                  } else {
                                    return const Center();
                                  }
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      ],
                    ),
                  ),
          const Divider(
            thickness: 1,
            color: Color.fromARGB(255, 212, 212, 212),
          )
        ],
      ),
    );
  }
}

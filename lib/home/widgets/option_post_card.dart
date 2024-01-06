import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/home/services/post_service.dart';

class OptionPostCard extends StatefulWidget {
  final snap;
  const OptionPostCard({super.key, this.snap});

  @override
  State<OptionPostCard> createState() => _OptionPostCardState();
}

class _OptionPostCardState extends State<OptionPostCard> {
  final PostServices postServices = PostServices();

  void savedPost(String postId, String flag) {
    postServices.savePost(context: context, postId: postId, flag: flag);
  }

  void hiddenPost(String postId) {
    postServices.hiddenPost(context: context, postId: postId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1 / 3.2,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
            height: 6,
            width: 50,
          ),
          const SizedBox(height: 24),
          Expanded(
              child: ListView(
            children: [
              GestureDetector(
                onTap: () => savedPost(widget.snap, "save"),
                child: const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.bookmark, size: 38),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save post",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Add this to your saved items.",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () => hiddenPost(widget.snap),
                child: const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.cancel_sharp, size: 38),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hide post",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "See fewer posts like this.",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {},
                child: const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.report, size: 38),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Report post",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Flag inappropriate posts for review.",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

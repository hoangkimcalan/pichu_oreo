import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/home/services/post_service.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/utils/colors.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostServices postServices = PostServices();
  static List<String> list = <String>['public', 'private'];
  bool _isLoading = false;
  String status = list.first;
  final TextEditingController _descriptionController = TextEditingController();

  List<File> images = [];

  void clearPostMem() {
    setState(() {
      images = [];
      _descriptionController.text = "";
    });
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void createPost(String userId) {
    setState(() {
      _isLoading = true;
    });

    postServices.createPost(
      context: context,
      description: _descriptionController.text,
      userId: userId,
      stautus: status,
      images: images,
    );

    setState(() {
      _isLoading = false;
    });
    clearPostMem();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Create post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => createPost(user.id),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const LinearProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/avatar_default.jpg',
                          ),
                          backgroundColor: Colors.white,
                          radius: 28, // set the desired radius
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              DropdownButton<String>(
                                dropdownColor:
                                    const Color.fromARGB(255, 244, 244, 244),
                                value: status,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                ),
                                style: const TextStyle(color: Colors.blue),
                                onChanged: (String? value) {
                                  setState(() {
                                    status = value!;
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: images.isNotEmpty
                          ? Column(
                              children: [
                                TextField(
                                  style: const TextStyle(fontSize: 20),
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    hintText: 'Write a caption...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 20),
                                  ),
                                  maxLines: 12,
                                ),
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
                                  ),
                                )
                              ],
                            )
                          : TextField(
                              style: const TextStyle(fontSize: 20),
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                hintText: 'Write a caption...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 20),
                              ),
                              maxLines: 20,
                            ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: selectImages,
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: const [
                                SizedBox(
                                  child: Icon(
                                    Icons.image_rounded,
                                    color: Colors.greenAccent,
                                    size: 36,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Image/video',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            child: Row(
                              children: const [
                                SizedBox(
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.blueAccent,
                                    size: 36,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Tag user',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            child: Row(
                              children: const [
                                SizedBox(
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.redAccent,
                                    size: 36,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Check in',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

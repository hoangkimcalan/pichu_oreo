import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  static List<Map<String, dynamic>> list = [
    {'value': 'public', 'icon': Icons.public},
    {'value': 'private', 'icon': Icons.lock}
  ];
  bool _isLoading = false;
  String status = list.first['value'];
  final TextEditingController _descriptionController = TextEditingController();
  int _current = 0;
  final CarouselController _controller = CarouselController();

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

  void takeImages() async {
    var res = await takeImage(ImageSource.camera);
    setState(() {
      images = res;
    });
  }

  void createPost(String userId) {
    if (_descriptionController.text.isNotEmpty || images.isNotEmpty) {
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
    } else {
      showSnackBar(context, 'Oops! Fill in the magic and add a pic. 📸✨');
    }
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
          'New post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => createPost(user.id),
              child: Container(
                width: 80,
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      'Save',
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
        ],
      ),
      body: _isLoading
          ? const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 251, 159, 182)),
            )
          : SingleChildScrollView(
              child: Padding(
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
                                    const Color.fromARGB(255, 255, 255, 255),
                                elevation: 1,
                                value: status,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                                style: const TextStyle(color: Colors.grey),
                                underline: Container(),
                                onChanged: (String? value) {
                                  setState(() {
                                    status = value!;
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> item) {
                                  return DropdownMenuItem<String>(
                                    value: item['value'],
                                    child: Row(
                                      children: [
                                        Icon(
                                          item['icon'],
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ), // Add spacing between icon and text
                                        Text(
                                          item['value'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: images.isNotEmpty
                            ? Column(
                                children: [
                                  TextField(
                                    style: const TextStyle(fontSize: 20),
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'What do you want to talk about ?',
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
                                    children:
                                        images.asMap().entries.map((entry) {
                                      return GestureDetector(
                                        onTap: () => _controller
                                            .animateToPage(entry.key),
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                (Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 211, 78, 111))
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 0.9
                                                            : 0.4),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            : TextField(
                                style: const TextStyle(fontSize: 20),
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  hintText: 'What do you want to talk about ?',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 20),
                                ),
                                maxLines: 23,
                              ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: selectImages,
                          child: const SizedBox(
                            child: Icon(
                              Icons.image_outlined,
                              color: Color(0xFF8d9096),
                              size: 32,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: takeImages,
                          child: const SizedBox(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFF8d9096),
                              size: 32,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const SizedBox(
                            child: Icon(
                              Icons.account_circle_outlined,
                              color: Color(0xFF8d9096),
                              size: 32,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const SizedBox(
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF8d9096),
                              size: 32,
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

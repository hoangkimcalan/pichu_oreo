import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/services/user_service.dart';
import 'package:pichu_oreo/common_widgets/text_field_input.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/utils/colors.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile-screen';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _workPlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final UserService userService = UserService();
  bool _isLoading = false;

  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _workPlController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
  }

  void pickAvaUpdate() async {
    var res = await pickAvatar();
    setState(() {
      images = res;
    });
  }

  void updateUserInfo(String firstName, String lastName, String workplace,
      String address, String phone, String avatar) {
    setState(() {
      _isLoading = true;
    });

    userService.updateUserInfo(
      context: context,
      firstName: _firstNameController.text == ''
          ? firstName
          : _firstNameController.text,
      lastName:
          _lastNameController.text == '' ? lastName : _lastNameController.text,
      workPlace:
          _workPlController.text == '' ? workplace : _workPlController.text,
      address:
          _addressController.text == '' ? address : _addressController.text,
      phone: _phoneController.text == '' ? phone : _phoneController.text,
      avatar: avatar,
      images: images,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (_lastNameController.text == '') {
      log("TEXT ${user.lastName}");
    } else {
      log("TEXT ${_lastNameController.text}");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  images.isEmpty
                      ? Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          alignment: Alignment.center,
                          height: 150,
                          child: Image.network(user.avatar, fit: BoxFit.fill),
                        )
                      : CarouselSlider(
                          items: images.map((e) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                e,
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 150,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            aspectRatio: 2.0,
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 240,
                    child: IconButton(
                      onPressed: pickAvaUpdate,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Divider(
                thickness: 0,
                color: Colors.grey,
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  hintText: 'First name',
                  labelText: user.firstName == '' ? null : user.firstName,
                  textInputType: TextInputType.text,
                  textEditingController: _firstNameController,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  hintText: 'Last name',
                  labelText: user.lastName == '' ? null : user.lastName,
                  textInputType: TextInputType.text,
                  textEditingController: _lastNameController,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  hintText: 'Work place',
                  labelText: user.workplace == '' ? null : user.workplace,
                  textInputType: TextInputType.text,
                  textEditingController: _workPlController,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  hintText: 'Address',
                  labelText: user.address == '' ? null : user.address,
                  textInputType: TextInputType.text,
                  textEditingController: _addressController,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldInput(
                  hintText: 'Phone',
                  labelText: user.phone == '' ? null : user.phone,
                  textInputType: TextInputType.text,
                  textEditingController: _phoneController,
                ),
              ),
              const SizedBox(height: 28),
              InkWell(
                onTap: () => updateUserInfo(
                  user.firstName,
                  user.lastName,
                  user.workplace,
                  user.address,
                  user.phone,
                  user.avatar,
                ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
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
    );
  }
}

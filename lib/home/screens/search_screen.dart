import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pichu_oreo/common_widgets/text_field_input.dart';
import 'package:pichu_oreo/home/services/post_service.dart';
import 'package:pichu_oreo/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PostServices postServices = PostServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _mediaListShow = [];

  int _currentPage = 0;

  Future<void> fetchData() async {
    try {
      log("Fetching medias...");
      List<Map<String, dynamic>> newData =
          await postServices.getAllImages(context: context, page: _currentPage);
      if (newData.isEmpty) {
        return;
      }
      _currentPage++;
      setState(() {
        _mediaListShow.addAll(newData);
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
    _searchController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFieldInput(
          hintText: "Search",
          textInputType: TextInputType.text,
          textEditingController: _searchController,
        ),
      ),
      body: MasonryGridView.count(
        crossAxisCount: 3,
        itemCount: _mediaListShow.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> itemMedia = _mediaListShow[index];
          return Image.network(
            itemMedia['mediaUrl'],
            fit: BoxFit.cover,
          );
        },
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }
}

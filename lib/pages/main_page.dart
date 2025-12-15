import 'dart:ui';

import 'package:cenima/models/search_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class MainPage extends ConsumerWidget {
  MainPage({super.key});
  double? deviceHight;
  double? deviceWidth;
  TextEditingController? _searchTextFieldController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    deviceHight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _searchTextFieldController = TextEditingController();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: deviceHight,
        width: deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [_backgroundImage(), _foregroundWidget()],
        ),
      ),
    );
  }

  Widget _backgroundImage() {
    return Container(
      width: deviceWidth,
      height: deviceHight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            "https://i.pinimg.com/736x/79/bc/e5/79bce5086cd9a48cdb758c570c91f599.jpg",
          ),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2)),
        ),
      ),
    );
  }

  Widget _foregroundWidget() {
    return Container(
      padding: EdgeInsets.only(top: deviceHight! * 0.02),
      width: deviceWidth! * 0.88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [_topBarWidget()],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: deviceHight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_searchFieldWidget(), _categorySelectionWidget()],
      ),
    );
  }

  Widget _searchFieldWidget() {
    final border = InputBorder.none;
    return SizedBox(
      width: deviceWidth! * 0.50,
      height: deviceHight! * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (input) {},
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: border,
          border: border,
          prefixIcon: Icon(Icons.search, color: Colors.white24),
          hintStyle: TextStyle(color: Colors.white54),
          filled: false,
          fillColor: Colors.white24,
          hintText: "Search....",
        ),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: SearchCategory().popular,
      icon: Icon(Icons.menu, color: Colors.white24),
      underline: Container(height: 1, color: Colors.white24),
      onChanged: (value) {},
      items: [
        DropdownMenuItem(
          value: SearchCategory().popular,
          child: Text(
            SearchCategory().popular,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory().upcoming,
          child: Text(
            SearchCategory().upcoming,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory().none,
          child: Text(
            SearchCategory().none,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

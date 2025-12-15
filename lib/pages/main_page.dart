import 'dart:ui';

import 'package:cenima/models/movie.dart';
import 'package:cenima/models/search_category.dart';
import 'package:cenima/widgets/movie_tile.dart';
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
        children: [
          _topBarWidget(),
          Container(
            height: deviceHight! * 0.83,
            padding: EdgeInsets.symmetric(horizontal: deviceHight! * 0.01),
            child: _movieListViewWidget(),
          ),
        ],
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

  _movieListViewWidget() {
    final List<Movie> movies = [];
    for (var i = 0; i < 20; i++) {
      movies.add(
        Movie(
          name: "john wick",
          language: "EN",
          isAdult: false,
          description:
              "     While working underground to fix a water main, Brooklyn plumbers—and brothers—Mario and Luigi are transported down a mysterious pipe and wander into a magical new world. But when the brothers are separated, Mario embarks on an epic quest to find Luigi",
          posterPath: "/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg",
          backdropPath: "/nDxJJyA5giRhXx96q1sWbOUjMBI.jpg",
          rating: 7.5,
          releaseDate: "2023-04-05",
        ),
      );
    }
    if (movies.isNotEmpty) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: deviceHight! * 0.01,
              horizontal: 0,
            ),
            child: GestureDetector(
              onTap: () {},
              child: MovieTile(
                movie: movies[index],
                height: deviceHight! * 0.20,
                width: deviceWidth! * 0.85,
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
    }
  }
}

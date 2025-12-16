import 'dart:ui';
import 'package:cenima/controllers/main_page_data_controller.dart';
import 'package:cenima/models/main_page_data.dart';
import 'package:cenima/models/movie.dart';
import 'package:cenima/models/search_category.dart';
import 'package:cenima/widgets/movie_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainPageDataControllerProvider =
    AsyncNotifierProvider<MainPageDataController, MainPageData>(
      MainPageDataController.new,
    );

// ignore: must_be_immutable
class MainPage extends ConsumerWidget {
  MainPage({super.key});
  double? deviceHight;
  double? deviceWidth;
  MainPageDataController? mainPageDataController;
  MainPageData? mainPageData;
  TextEditingController? _searchTextFieldController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    deviceHight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    final asyncData = ref.watch(mainPageDataControllerProvider);
    mainPageDataController = ref.read(mainPageDataControllerProvider.notifier);
    return asyncData.when(
      loading: () => Stack(
        children: [
          _backgroundImage(),
          Center(
            child: const CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (data) {
        _searchTextFieldController ??= TextEditingController(
          text: data.searchText,
        );

        return _buildUI(data);
      },
    );
  }

  Widget _buildUI(MainPageData data) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: deviceHight,
        width: deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [_backgroundImage(), _foregroundWidget(data)],
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

  Widget _foregroundWidget(MainPageData data) {
    return Container(
      padding: EdgeInsets.only(top: deviceHight! * 0.02),
      width: deviceWidth! * 0.88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          _topBarWidget(data),
          Container(
            height: deviceHight! * 0.83,
            padding: EdgeInsets.symmetric(horizontal: deviceHight! * 0.01),
            child: _movieListViewWidget(data.movies),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget(MainPageData data) {
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
        children: [_searchFieldWidget(), _categorySelectionWidget(data)],
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
        onSubmitted: (value) {
          mainPageDataController!.updateTextSearch(value);
        },
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

  Widget _categorySelectionWidget(MainPageData data) {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: data.searchCategory,
      icon: Icon(Icons.menu, color: Colors.white24),
      underline: Container(height: 1, color: Colors.white24),
      onChanged: (value) => value.toString().isNotEmpty
          ? mainPageDataController!.updateSearchCategory(value.toString())
          : null,
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

  _movieListViewWidget(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(
        child: Text("No Movies =..", style: TextStyle(color: Colors.white)),
      );
    }

    if (movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;
            if (before >= max - 100) {
              mainPageDataController!.loadNextPage();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.only(top: deviceHight! * 0.02),
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
        ),
      );
    }
  }
}

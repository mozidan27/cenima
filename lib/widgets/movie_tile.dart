import 'package:cenima/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MovieTile extends StatelessWidget {
  MovieTile({
    super.key,
    required this.height,
    required this.width,
    required this.movie,
  });
  final double height;
  final double width;
  final Movie movie;
  final GetIt getIt = GetIt.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(movie.posterURl()),
          // SizedBox(width: width * 0.04),
          _movieInfoWidget(),
        ],
      ),
    );
  }

  Widget _movieInfoWidget() {
    return SizedBox(
      height: height,
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.56,
                child: Text(
                  movie.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Text(
                movie.rating.toString(),
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String imageUrl) {
    return Container(
      height: height,
      width: width * 0.30,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imageUrl)),
      ),
    );
  }
}

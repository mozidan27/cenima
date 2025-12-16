import 'package:cenima/models/main_page_data.dart';
import 'package:cenima/models/search_category.dart';
import 'package:cenima/services/movie_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class MainPageDataController extends AsyncNotifier<MainPageData> {
  final MovieService _movieService = GetIt.instance.get<MovieService>();

  @override
  Future<MainPageData> build() async {
    return await getMovies();
  }

  Future<MainPageData> getMovies() async {
    try {
      final movies = await _movieService.getPopularMovies(page: 1);
      return MainPageData(
        movies: movies,
        page: 1,
        searchCategory: SearchCategory().popular,
        searchText: '',
      );
    } catch (e) {
      // ممكن ترجع state فاضية أو تبني AsyncError
      return MainPageData.initial();
    }
  }
}

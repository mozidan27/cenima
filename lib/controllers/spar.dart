import 'package:cenima/models/main_page_data.dart';
import 'package:cenima/models/search_category.dart';
import 'package:cenima/services/movie_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class MainPageDataController extends AsyncNotifier<MainPageData> {
  final MovieService _movieService = GetIt.instance.get<MovieService>();

  @override
  Future<MainPageData> build() async {
    return _loadByCategory(SearchCategory().popular);
  }

  Future<MainPageData> _loadByCategory(String category) async {
    final movies = category == SearchCategory().upcoming
        ? await _movieService.getUpcomingMovies(page: 1)
        : await _movieService.getPopularMovies(page: 1);

    return MainPageData(
      movies: movies,
      page: 1,
      searchCategory: category,
      searchText: '',
    );
  }

  Future<void> updateSearchCategory(String category) async {
    state = const AsyncLoading();

    try {
      final movies = category == SearchCategory().upcoming
          ? await _movieService.getUpcomingMovies(page: 1)
          : await _movieService.getPopularMovies(page: 1);

      state = AsyncData(
        state.value!.copyWith(
          movies: movies,
          searchCategory: category,
          searchText: '', // 🔥 نمسح السيرش
          page: 1,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //! chat gpt
  Future<void> updateTextSearch(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      // لو مسح النص، نرجع للـ category الحالي
      await updateSearchCategory(state.value!.searchCategory);
      return;
    }

    state = const AsyncLoading();
    try {
      // جلب النتائج من API
      final moviesFromApi = await _movieService.getSearchMovies(
        searchTerm,
        page: 1,
      );

      // فلترة حرفية locally على أي حقل (title, description, language)
      final filtered = moviesFromApi.where((movie) {
        final term = searchTerm.toLowerCase();
        return movie.name.toLowerCase().contains(term) ||
            movie.description.toLowerCase().contains(term) ||
            movie.language.toLowerCase().contains(term);
      }).toList();

      state = AsyncData(
        state.value!.copyWith(
          movies: filtered,
          searchText: searchTerm,
          page: 1,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      print("Search Error: $e");
    }
  }
}

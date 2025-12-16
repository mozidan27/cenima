import 'package:cenima/models/movie.dart';
import 'package:cenima/services/http_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  HttpService? http;

  MovieService() {
    http = getIt.get<HttpService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response response = await http!.get(
      "/movie/popular",
      query: {'page': page},
    );
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((moviedata) {
        return Movie.fromJson(moviedata);
      }).toList();
      return movies;
    } else {
      throw Exception("couldn't load popular movies");
    }
  }

  Future<List<Movie>> getUpcomingMovies({int? page}) async {
    Response response = await http!.get(
      "/movie/upcoming",
      query: {'page': page},
    );
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((moviedata) {
        return Movie.fromJson(moviedata);
      }).toList();
      return movies;
    } else {
      throw Exception("couldn't load upcoming movies");
    }
  }

  Future<List<Movie>> getSearchMovies(String searchTerm, {int? page}) async {
    final queryPage = page ?? 1;

    Response response = await http!.get(
      "/search/movie",
      query: {'query': searchTerm, 'page': queryPage},
    );

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.data}');

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      List<Movie> movies = results.map((moviedata) {
        return Movie.fromJson(moviedata);
      }).toList();
      return movies;
    } else {
      throw Exception(
        "couldn't perform movie search, status: ${response.statusCode}",
      );
    }
  }
}

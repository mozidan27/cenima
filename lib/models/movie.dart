import 'package:cenima/models/app_config.dart';
import 'package:get_it/get_it.dart';

class Movie {
  final String name;
  final String language;
  final bool isAdult;
  final String description;
  final String posterPath;
  final String backdropPath;
  final num rating;
  final String releaseDate;

  Movie({
    required this.name,
    required this.language,
    required this.isAdult,
    required this.description,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> jsonData) {
    return Movie(
      name: jsonData["title"] ?? 'No Title',
      language: jsonData["original_language"] ?? 'en',
      isAdult: jsonData["adult"] ?? false,
      description: jsonData["overview"] ?? '',
      posterPath: jsonData["poster_path"] ?? '',
      backdropPath: jsonData["backdrop_path"] ?? '',
      rating: (jsonData["vote_average"] ?? 0).toDouble(),
      releaseDate: jsonData["release_date"] ?? '',
    );
  }

  String posterURl() {
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return "${appConfig.baseImageApiUrl}$posterPath";
  }
}

/// TMDB v3 endpoints. Paths only, the host is added by the api client.
class Api {
  const Api._();

  static const String baseUrl = 'https://api.themoviedb.org/3';

  /// Daily, so the list changes between launches.
  static const String trendingMovies = '/trending/movie/day';

  static const String searchMovies = '/search/movie';

  /// Runtime, genres and tagline only come from here.
  static String movieDetails(int id) => '/movie/$id';
}

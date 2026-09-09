class Api {
  const Api._();

  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String trendingMovies = '/trending/movie/day';

  static const String searchMovies = '/search/movie';

  static String movieDetails(int id) => '/movie/$id';

  static String movieRecommendations(int id) => '/movie/$id/recommendations';
}
